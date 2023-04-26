from itertools import permutations


def myPermutations(list_of_elements, first=False):
    perm = list(permutations(list_of_elements))
    tabs = "\t" * 8

    print(tabs, end="")
    if not first:
        print("| ", end="")
    for elem in perm[0]:
        print(elem, end=" ")
    print(f"\n{tabs}| ", end="")

    for index in range(1, len(perm) - 1):
        for elem in perm[index]:
            print(elem, end=" ")
        print(f"\n{tabs}| ", end="")

    for elem in perm[len(perm) - 1]:
        print(elem, end=" ")
    print()


ypochreotika = ["text", "layoutWidth", "layoutHeight"]
id = ypochreotika + ["id"]
max = ypochreotika + ["max"]
progress = ypochreotika + ["progress"]
all = ypochreotika + ["id", "padding", "progress"]

myPermutations(ypochreotika, first=True)
myPermutations(id)
myPermutations(max)
myPermutations(all)

