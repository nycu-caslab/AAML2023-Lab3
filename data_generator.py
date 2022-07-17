import numpy as np
import argparse
import random
import os


    



def write_matrix(fd, m):

    r, c = m.shape


    calign = int((c+3)/4)*4

    malign = np.zeros((r, calign), dtype=np.uint8)

    malign[:, 0:c] = m
    cptr = 0

    fd.write("\n")
    for cptr in range(0, calign, 4):
        for dr in range(r):
            for n in range(4):
                # t = f"{malign[dr, cptr+n]}"
                fd.write("{0:2x} ".format(malign[dr, cptr+n]))
            fd.write('\n')
            

    fd.write("\n")

    return malign

def write_output_matrix(fd, m):
    r, c = m.shape


    calign = int((c+3)/4)*4

    malign = np.zeros((r, calign), dtype=np.uint32)

    malign[:, 0:c] = m
    cptr = 0

    fd.write("\n")
    for cptr in range(0, calign, 4):
        for dr in range(r):
            for n in range(4):
                # t = f"{malign[dr, cptr+n]}"
                fd.write("{0:8x} ".format(malign[dr, cptr+n]))
            fd.write('\n')
            
    fd.write("\n")

    return malign


def write_readable(fd, m, desc=""):
    r, c = m.shape

    fd.write(desc)
    for dr in range(r):
        for dc in range(c):
            fd.write("{0:6d} ".format( m[dr, dc]))
        fd.write("\n")
    fd.write("\n")

def write_config(fd, K, M, N):

    fd.write("{0:3x} {1:3x} {2:3x}".format( K, M, N))


def gen_one_case(i, in_fd=None, c_fd=None, all_one=False, mode=0, shape_range=(4, 255), val_range=(0, 255)):

    if in_fd == None:
        print("input file descriptor is null")
        exit(2)
    
    if c_fd == None:
        print("check file descriptor is null")
        exit(2)


    K = 0
    M = 0
    N = 0
    if mode == 0:
        K = M = N = 2
    elif mode == 1:
        K = M = N = 4
    elif mode == 2:
        K = random.randint(shape_range[0], shape_range[1])
        M = 4
        N = 4
    elif mode == 3:
        K = random.randint(shape_range[0], shape_range[1])
        M = random.randint(shape_range[0], shape_range[1])
        N = random.randint(shape_range[0], shape_range[1])

    #* generate the matrix

    if all_one:
        Am = np.ones((M, K), dtype=np.uint8)
        Bm = np.ones((K, N), dtype=np.uint8)
    else:
        Am = np.random.randint(val_range[0], high=val_range[1], size=(M, K), dtype=np.uint8)
        Bm = np.random.randint(val_range[0], high=val_range[1], size=(K, N), dtype=np.uint8)


    Cm = np.matmul(Am, Bm, dtype=np.uint32)
    AmT = Am.transpose()

    # print(K, M, N)
    # print(AmT)
    # print(Bm)

    write_config(in_fd, K, M, N)
    write_matrix(in_fd, AmT)
    write_matrix(in_fd, Bm)
    write_output_matrix(in_fd, Cm)


    c_fd.write("----------------------------------------------\n")
    c_fd.write(f"                 Case {i}                    \n")
    c_fd.write("----------------------------------------------\n")
    c_fd.write(f"K: {K:3d} M: {M:3d} N:{N:3d}\n")
    write_readable(c_fd, Am, desc="A: \n")
    write_readable(c_fd, Bm, desc ="B: \n")
    write_readable(c_fd, Cm, desc="C: \n")


def main():


    parser = argparse.ArgumentParser()

    parser.add_argument('--mode', type=int, required=True, default=0, help="The mode of the generated version")
    parser.add_argument('--ncases', type=int, required=True, default=1, help="The number of cases to be generated")
    parser.add_argument('--ones', action="store_true", help="To specify all content of matrix is one")
    parser.add_argument('--target_dir', type=str, required=True, help="The Output directory for testcases")



    args = parser.parse_args()


    mode = args.mode
    ncases = args.ncases
    all_one = True if args.ones else False
    target_dir = args.target_dir


    try:
        os.mkdir(target_dir, 0o755)
    except OSError as error:
        print(error)

    input_file = os.path.join(target_dir, "input.txt")
    leg_file   = os.path.join(target_dir, "check.txt")

    in_fd = open(input_file, "w")
    legible_fd = open(leg_file, "w")

    for n in range(ncases):
        gen_one_case(n, in_fd, legible_fd, all_one=all_one, mode=mode, shape_range=(4, 255), val_range=(0, 255))

    # K = 0
    # M = 0
    # N = 0
    # if mode == 0:
    #     K = M = N = 2
    # elif mode == 1:
    #     K = M = N = 4
    # elif mode == 2:
    #     K = random.randint(4, 256)
    #     M = 4
    #     N = 4
    # elif mode == 3:
    #     K = random.randint(4, 15)
    #     M = random.randint(4, 15)
    #     N = random.randint(4, 15)

    # #* generate the matrix

    # if all_one:
    #     Am = np.ones((M, K), dtype=np.uint8)
    #     Bm = np.ones((K, N), dtype=np.uint8)
    # else:
    #     Am = np.random.randint(0, high=255, size=(M, K), dtype=np.uint8)
    #     Bm = np.random.randint(0, high=255, size=(K, N), dtype=np.uint8)

    # AmT = Am.transpose()

    # print(K, M, N)
    # print(AmT)
    # print(Bm)




    # write_config(in_fd, K, M, N)
    # write_matrix(in_fd, AmT)
    # write_matrix(in_fd, Bm)


    # legible_fd.write("----------------------------------------------\n")
    # legible_fd.write(f"                 Case {1}                    \n")
    # legible_fd.write("----------------------------------------------\n")
    # legible_fd.write(f"K: {K:3d} M: {M:3d} N:{N:3d}\n")
    # write_readable(legible_fd, AmT, desc="A: \n")
    # write_readable(legible_fd, Bm, desc ="B: \n")


    


if __name__ == "__main__":
    main()

    
    



















































