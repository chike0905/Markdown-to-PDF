# -*- coding: utf8 -*-
import sys
import re


def replacelines(lines):
    for i in range(len(lines)):
        line = lines[i]
        line = replaceImageImport(line)

        # replace wide figure places
        if re.match(".*label{fig:wide:.*}", line):
            print(line)
            s = i
            while True:
                if 'begin{figure}' in lines[s]:
                    figline = lines[s]
                    print(figline)
                    figline = figline.replace(
                        'begin{figure}', 'begin{figure*}')
                    lines[s] = figline
                    break
                s -= 1
            s = i
            while True:
                if 'end{figure}' in lines[s]:
                    figline = lines[s]
                    print(figline)
                    figline = figline.replace(
                        'end{figure}', 'end{figure*}')
                    lines[s] = figline
                    break
                s += 1
        # replace textasciitilde
        if re.match(".*textasciitilde.*", line):
            print(line)
            line = line.replace(
                r'\textasciitilde{}',
                '~')
            print(line)
        lines[i] = line
    return lines


def replaceImageImport(line):
    if 'includegraphics' in line:
        line = line.replace('includegraphics{',
                            'includegraphics[width=\linewidth]{tmp/')
    if 'begin{figure}' in line:
        line = line.replace('begin{figure}', 'begin{figure}[t]')
    return line


if __name__ == '__main__':
    filename = sys.argv[1]
    with open(filename, 'r') as f:
        lines = f.readlines()

    lines = replacelines(lines)
    with open(filename, 'w') as f:
        f.writelines(lines)
