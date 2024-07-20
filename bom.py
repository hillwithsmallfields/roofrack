#!/usr/bin/env python3

import argparse
import collections
import csv

def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--pieces")
    parser.add_argument("--groups")
    parser.add_argument("--cuts")
    return vars(parser.parse_args())

def bom(pieces, groups, cuts):
    with open(pieces) as instream, open(groups, 'w') as groupstream, open(cuts, 'w') as cutstream:
        reader = csv.reader(instream)
        groupwriter = csv.writer(groupstream)
        cutwriter = csv.writer(cutstream)
        materials = collections.defaultdict(lambda: collections.defaultdict(list))
        for row in reader:
            if len(row) >= 4:
                material_type, length, orientation, name = row
                materials[material_type][round(float(length))].append(name.strip('" '))
        for_doubling = collections.defaultdict(collections.Counter)
        for material, lengths in materials.items():
            for length, pieces in lengths.items():
                names = collections.Counter(pieces)
                for_removal = collections.Counter()
                double_pieces = collections.Counter()
                for name, quantity in names.items():
                    if name.startswith("half of ") and quantity%2 == 0:
                        half_of_what = name.removeprefix("half of ")
                        for_removal[name] = quantity
                        double_pieces[half_of_what] = int(quantity/2)
                if double_pieces:
                    for_doubling[length*2] += double_pieces
                lengths[length] = names - for_removal
        for length, doubles in for_doubling.items():
            lengths[length] = collections.Counter(lengths[length]) + doubles
        for material in sorted(materials.keys()):
            lengths = materials[material]
            for length in sorted(lengths):
                pieces = lengths[length]
                cutwriter.writerow([material, length,
                                    # sum(pieces.values())
                                    sum(pieces.values())
                                    ])
                names = collections.Counter(pieces)
                for name in sorted(names.keys()):
                    groupwriter.writerow([material, length, names[name], name])

if __name__ == "__main__":
    bom(**get_args())
