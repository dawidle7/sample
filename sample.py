import argparse


parser = argparse.ArgumentParser()
parser.add_argument("-e", type=ascii)
args=parser.parse_args()

print(args.e)

