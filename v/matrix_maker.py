import random

def generate_random_matrix(width, height, zero_weight):
    matrix = []
    for _ in range(height):
        row = []
        for _ in range(width):
            value = random.choices([0, 1], weights=[zero_weight, 1-zero_weight])[0]
            row.append(value)
        matrix.append(row)
    for j in range(width):
        has_one = False
        for i in range(height):
            if matrix[i][j]:
                has_one = True
                break
        if not has_one:
            height_idx = random.randint(0, height-1)
            matrix[height_idx][j] = 1
        
    return matrix

def print_matrix_verilog(matrix):
    rows = len(matrix)
    cols = len(matrix[0])

    print("logic [{}:0] matrix [{}];".format(cols - 1, rows))

    for i, row in enumerate(matrix):
        bus_value = ''.join(str(bit) for bit in row)
        print("assign matrix[{}] = {}'b{};".format(i, cols, bus_value))

def print_matrix_c(matrix):
    rows = len(matrix)
    cols = len(matrix[0])

    print("int matrix[{}][{}] = {{".format(rows, cols))
    for row in matrix:
        print("        {0b", end="")
        for i in range(cols):
            print(row[i], end="")
            if i != cols - 1:
                print("", end="")
        print("},")
    print("};")

# Prompt user for width and height
width = 20
height = 4
weight = .5

# Generate and print the random matrix
random_matrix = generate_random_matrix(width, height, weight)
print("\nRandom Matrix:")
print_matrix_c(random_matrix)
print_matrix_verilog(random_matrix)
