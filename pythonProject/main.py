# to activate virtual environment  (LINUX)
# source pythonProject/venv/bin/activate 

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

def myPermutationsWithErrors(list_of_elements, message, first=False):
    perm = list(permutations(list_of_elements))
    tabs = '\t'*7 + "  "


    if not first:
        print(f"{tabs}|  ", end="")
    for elem in perm[0]:
        print(f'{elem}', end=" ")
    print(f'\t\t\t {message} \n{tabs}|  ', end="")

    for index in range(1, len(perm) - 1):
        for elem in perm[index]:
            print(elem, end=" ")
        print(f'\t\t\t {message}\n{tabs}|  ', end="")

    for elem in perm[len(perm) - 1]:
        print(elem, end=" ")
    print(f'\t\t\t {message}\n', end="")


height = ["layoutWidth", "error"]
width = ["error", "layoutHeight"]

height_id = ["id","layoutWidth", "error"]
width_id = ["id", "error", "layoutHeight"]


myPermutationsWithErrors(height, '{ yyerror("android:layout_height is mandatory"); yyerrok; }', first=False)
myPermutationsWithErrors(width, '{ yyerror("android:layout_width is mandatory"); yyerrok; }', first=False)

myPermutationsWithErrors(height_id, '{ yyerror("android:layout_height is mandatory"); yyerrok; }', first=False)
myPermutationsWithErrors(width_id, '{ yyerror("android:layout_width is mandatory"); yyerrok; }', first=False)