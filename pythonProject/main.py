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
nes = ['layoutHeight', 'layoutWidth', 'source']
id = ['layoutHeight', 'layoutWidth', 'id', 'source']
padding = ['layoutHeight', 'layoutWidth', 'source', 'padding']
all = ['layoutHeight', 'layoutWidth', 'source', 'id', 'padding']

myPermutations(nes, True)
myPermutations(id)
myPermutations(padding)
myPermutations(all)

# errors (height)
nes = ['error', 'layoutWidth', 'source']
id = ['error', 'layoutWidth', 'id', 'source']
padding = ['error', 'layoutWidth', 'source', 'padding']
all = ['error', 'layoutWidth', 'source', 'id', 'padding']

myPermutationsWithErrors(nes, '{ yyerror("android:layoutHeight is mandatory!"); yyerrok; }')
myPermutationsWithErrors(id, '{ yyerror("android:layoutHeight is mandatory!"); yyerrok; }')
myPermutationsWithErrors(padding, '{ yyerror("android:layoutHeight is mandatory!"); yyerrok; }')
myPermutationsWithErrors(all, '{ yyerror("android:layoutHeight is mandatory!"); yyerrok; }')

# width
nes = ['layoutHeight', 'error', 'source']
id = ['layoutHeight', 'error', 'id', 'source']
padding = ['layoutHeight', 'error', 'source', 'padding']
all = ['layoutHeight', 'error', 'source', 'id', 'padding']

myPermutationsWithErrors(nes, '{ yyerror("android:layoutWidth is mandatory!"); yyerrok; }')
myPermutationsWithErrors(id, '{ yyerror("android:layoutWidth is mandatory!"); yyerrok; }')
myPermutationsWithErrors(padding, '{ yyerror("android:layoutWidth is mandatory!"); yyerrok; }')
myPermutationsWithErrors(all, '{ yyerror("android:layoutWidth is mandatory!"); yyerrok; }')

# source
nes = ['layoutHeight', 'layoutWidth', 'error']
id = ['layoutHeight', 'layoutWidth', 'id', 'error']
padding = ['layoutHeight', 'layoutWidth', 'error', 'padding']
all = ['layoutHeight', 'layoutWidth', 'error', 'id', 'padding']

myPermutationsWithErrors(nes, '{ yyerror("android:src is mandatory!"); yyerrok; }')
myPermutationsWithErrors(id, '{ yyerror("android:src is mandatory!"); yyerrok; }')
myPermutationsWithErrors(padding, '{ yyerror("android:src is mandatory!"); yyerrok; }')
myPermutationsWithErrors(all, '{ yyerror("android:src is mandatory!"); yyerrok; }')