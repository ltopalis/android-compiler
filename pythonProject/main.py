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
    tabs = '\t' * 7 + " " * 4

    if not first:
        print(f"{tabs}|  ", end="")
    for elem in perm[0]:
        print(f'{elem}', end=" ")
    print(f'\t\t\t\t {message} \n{tabs}|  ', end="")

    for index in range(1, len(perm) - 1):
        for elem in perm[index]:
            print(elem, end=" ")
        print(f'\t\t\t\t {message}\n{tabs}|  ', end="")

    for elem in perm[len(perm) - 1]:
        print(elem, end=" ")
    print(f'\t\t\t\t {message}\n', end="")


# correct
nes = ['layoutHeight', 'layoutWidth', 'maxChildren']
id = ['layoutHeight', 'layoutWidth', 'id', 'maxChildren']
checked = ['layoutHeight', 'layoutWidth', 'maxChildren', 'checkedButton']
all = ['layoutHeight', 'layoutWidth', 'maxChildren', 'id', 'checkedButton']

myPermutations(nes, True)
myPermutations(id)
myPermutations(checked)
myPermutations(all)

# errors (height)
nes = ['error', 'layoutWidth', 'maxChildren']
id = ['error', 'layoutWidth', 'id', 'maxChildren']
checked = ['error', 'layoutWidth', 'maxChildren', 'checkedButton']
all = ['error', 'layoutWidth', 'maxChildren', 'id', 'checkedButton']

myPermutationsWithErrors(nes, '{ yyerror("android:layoutHeight is mandatory!"); yyerrok; }')
myPermutationsWithErrors(id, '{ yyerror("android:layoutHeight is mandatory!"); yyerrok; }')
myPermutationsWithErrors(checked, '{ yyerror("android:layoutHeight is mandatory!"); yyerrok; }')
myPermutationsWithErrors(all, '{ yyerror("android:layoutHeight is mandatory!"); yyerrok; }')

# width
nes = ['layoutHeight', 'error', 'maxChildren']
id = ['layoutHeight', 'error', 'id', 'maxChildren']
checked = ['layoutHeight', 'error', 'maxChildren', 'checkedButton']
all = ['layoutHeight', 'error', 'maxChildren', 'id', 'checkedButton']

myPermutationsWithErrors(nes, '{ yyerror("android:layoutWidth is mandatory!"); yyerrok; }')
myPermutationsWithErrors(id, '{ yyerror("android:layoutWidth is mandatory!"); yyerrok; }')
myPermutationsWithErrors(checked, '{ yyerror("android:layoutWidth is mandatory!"); yyerrok; }')
myPermutationsWithErrors(all, '{ yyerror("android:layoutWidth is mandatory!"); yyerrok; }')

# maxChildren
nes = ['layoutHeight', 'layoutWidth', 'error']
id = ['layoutHeight', 'layoutWidth', 'id', 'error']
checked = ['layoutHeight', 'layoutWidth', 'error', 'checkedButton']
all = ['layoutHeight', 'layoutWidth', 'error', 'id', 'checkedButton']

myPermutationsWithErrors(nes, '{ yyerror("android:maxChildren is mandatory!"); yyerrok; }')
myPermutationsWithErrors(id, '{ yyerror("android:maxChildren is mandatory!"); yyerrok; }')
myPermutationsWithErrors(checked, '{ yyerror("android:maxChildren is mandatory!"); yyerrok; }')
myPermutationsWithErrors(all, '{ yyerror("android:maxChildren is mandatory!"); yyerrok; }')