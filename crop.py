#!/usr/bin/python3

from PyPDF2 import PdfFileWriter, PdfFileReader
import sys


def main():
    if len(sys.argv) < 3:
        print('Input file and output file must be specified')
        return 1
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    with open(input_file, "rb") as in_file:
        file_reader = PdfFileReader(in_file)
        file_writer = PdfFileWriter()

        numPages = file_reader.getNumPages()

        # for i in range(24, numPages):
        for i in range(24, numPages - 1):
            page = file_reader.getPage(i)
            # page.cropBox.lowerLeft = (60, 136)
            # page.cropBox.upperRight = (540, 703)
            page.cropBox.lowerLeft = (60, 130)
            page.cropBox.upperRight = (540, 715)
            file_writer.addPage(page)

        with open(output_file, "wb") as out_f:
            file_writer.write(out_f)


if __name__ == '__main__':
    main()
