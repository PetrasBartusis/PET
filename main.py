from sys import *

tokens = []
num_stack = []
symbols = {}


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
    varStarted = 0
    var = ""
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
            elif var != "":
                tokens.append("pet:" + var[3:])
                var = ""
                varStarted = 0
            tok = ""
        elif tok == "=" and state == 0:
            if var != "":
                tokens.append("pet:" + var[3:])
                var = ""
                varStarted = 0
            tokens.append("EQUALS")
            tok = ""
        elif tok == "pet" and state == 0:
            varStarted = 1
            var += tok
            tok = ""
        elif varStarted == 1:
            if tok == "<" or tok == ">":
                if var != "":
                    tokens.append("pet:" + var[3:])
                    var = ""
                    varStarted = 0
            var += tok
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
    print(tokens)
    # symbols["variable"] = "Hello"
    # print(symbols)
    # return ''
    return tokens


def evalExpression(expr):
    return eval(expr)
    # expr = "," + expr
    # i = len(expr) - 1
    # num = ""
    # while i >= 0:
    #     # print(expr[i])
    #     if (expr[i] == "+" or expr[i] == "-" or expr[i] == "/" or expr[i] == "*" or expr[i] == "%"):
    #         num_stack.append(num)
    #         num_stack.append(expr[i])
    #         num = ""
    #     elif (expr[i] == ","):
    #         num = num[::-1]
    #         num_stack.append(num)
    #         num = ""
    #     else:
    #         num += expr[i]
    #     i-=1
    # print(num_stack)


def doPrint(toprint):
    if toprint[0:6] == "string":
        toprint = toprint[8:]
        toprint = toprint[:-1]
    elif toprint[0:3] == "num":
        toprint = toprint[4:]
    elif toprint[0:4] == "expr":
        toprint = evalExpression(toprint[5:])
    print(toprint)


def doASSIGN(varname, varvalue):
    symbols[varname[4:]] = varvalue


def getVARIABLE(varname):
    varname = varname[4:]
    if varname in symbols:
        return symbols[varname]
    else:
        return "VARIABLE ERROR: Undefined variable"

def parse(toks):
    i = 0
    while i < len(toks):
        if toks[i] + " " + toks[i + 1][0:6] == "out string" or toks[i] + " " + toks[i + 1][0:3] == "out num" or toks[i] + " " + toks[i + 1][0:4] == "out expr" or toks[i] + " " + toks[i + 1][0:3] == "out num" or toks[i] + " " + toks[i + 1][0:3] == "out pet":
            if toks[i + 1][0:6] == "string":
                doPrint(toks[i + 1])
            elif toks[i + 1][0:3] == "num":
                doPrint(toks[i + 1])
            elif toks[i + 1][0:4] == "expr":
                doPrint(toks[i + 1])
            elif toks[i + 1][0:3] == "pet":
                doPrint(getVARIABLE(toks[i+1]))
            i += 2
        elif toks[i][0:3] + " " + toks[i+1] + " " + toks[i+2][0:6] == "pet EQUALS string" or toks[i][0:3] + " " + toks[i+1] + " " + toks[i+2][0:3] == "pet EQUALS num" or toks[i][0:3] + " " + toks[i+1] + " " + toks[i+2][0:4] == "pet EQUALS expr":
            if toks[i + 2][0:6] == "string":
                doASSIGN(toks[i], toks[i+2])
            elif toks[i + 2][0:3] == "num":
                doASSIGN(toks[i], toks[i+2])
            elif toks[i + 2][0:4] == "expr":
                doASSIGN(toks[i], "num:" + str(evalExpression(toks[i+2][5:])))
            # print(toks[i+2])
            i += 3
    print(symbols)


def run():
    data = open_file(argv[1])
    toks = lex(data)
    parse(toks)


run()
