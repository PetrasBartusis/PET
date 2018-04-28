from sys import *

tokens = []


def open_file(filename):
    data = open(filename, "r").read()
    data += "<EOF>"
    return data


def lex(filecontents):
    tok = ""
    state = 0
    string = ""
    filecontents = list(filecontents)
    expr = ""
    number = ""
    isexpr = False
    for char in filecontents:
        tok += char

        if tok == " ":
            if state == 0:
                tok = ""
            else:
                tok = " "

        elif tok == "\n" or tok == "<EOF>":
            if expr != "" and isexpr:
                tokens.append("expr:" + expr)
                expr = ""
            elif expr != "" and not isexpr:
                tokens.append("num:" + expr)
                expr = ""
            tok = ""

        elif tok == "out":
            tokens.append("out")
            tok = ""
        elif tok == "0" or tok == "1" or tok == "2" or tok == "3" or tok == "4" or tok == "5" or tok == "6" or tok == "7" or tok == "8" or tok == "9":
            expr += tok
            tok = ""
        elif tok == "+" or tok == "-" or tok == "/" or tok == "(" or tok == ")" or tok == "*":
            isexpr = True
            expr += tok
            tok = ""
        elif tok == "\"":
            if state == 0:
                state = 1
            elif state == 1:
                tokens.append("string:" + string + "\"")
                string = ""
                state = 0
                tok = ""
        elif state == 1:
            string += tok
            tok = ""
    # print(tokens)
    return tokens


def doPrint(toprint):
    if toprint[0:6] == "string":
        toprint = toprint[8:]
        toprint = toprint[:-1]
    elif toprint[0:3] == "num":
        toprint = toprint[4:]
    elif toprint[0:4] == "expr":
        toprint = toprint[5:]
    print(toprint)


def parse(toks):
    i = 0
    while i < len(toks):
        if toks[i] + " " + toks[i + 1][0:6] == "out string" or toks[i] + " " + toks[i + 1][0:3] == "out num" or toks[i]\
                + " " + toks[i + 1][0:4] == "out expr":
            if toks[i + 1][0:6] == "string":
                doPrint(toks[i + 1])
            elif toks[i + 1][0:3] == "num":
                doPrint(toks[i + 1])
            elif toks[i + 1][0:4] == "expr":
                doPrint(toks[i + 1])
            i += 2


def run():
    data = open_file(argv[1])
    toks = lex(data)
    parse(toks)


run()
