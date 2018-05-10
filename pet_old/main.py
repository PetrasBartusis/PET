from sys import *

tokens = []
num_stack = []
symbols = {}
# token constants
STRING_TOKEN = "string"
VARIABLE_TOKEN = "pet"
EXPRESSION_TOKEN = "expr"
NUMBER_TOKEN = "num"
PRINT_TOKEN = "out"
INPUT_TOKEN = "in"
EQUALS_TOKEN = "EQUALS"
TERM_TOKEN = "term"
THEN_TOKEN = "then"
ENDTERM_TOKEN = "endterm"
IS_EQUALS_TOKEN = "iseq"

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
                tokens.append(colonToken(EXPRESSION_TOKEN) + expr)
                expr = ""
            elif expr != "" and not isexpr:
                tokens.append(colonToken(NUMBER_TOKEN) + expr)
                expr = ""
            elif var != "":
                tokens.append(colonToken(VARIABLE_TOKEN) + var[3:])
                var = ""
                varStarted = 0
            tok = ""
        elif tok == "=" and state == 0:
            if expr != "" and not isexpr:
                tokens.append(colonToken(NUMBER_TOKEN) + expr)
                expr = ""
            if var != "":
                tokens.append(colonToken(VARIABLE_TOKEN) + var[3:])
                var = ""
                varStarted = 0
            if tokens[-1] == EQUALS_TOKEN:
                tokens[-1] = IS_EQUALS_TOKEN
            else:
                tokens.append(EQUALS_TOKEN)
            tok = ""
        elif tok == VARIABLE_TOKEN and state == 0:
            varStarted = 1
            var += tok
            tok = ""
        elif varStarted == 1:
            if tok == "<" or tok == ">":
                if var != "":
                    tokens.append(colonToken(VARIABLE_TOKEN) + var[3:])
                    var = ""
                    varStarted = 0
            var += tok
            tok = ""
        elif tok == PRINT_TOKEN:
            tokens.append(PRINT_TOKEN)
            tok = ""
        elif tok == TERM_TOKEN:
            tokens.append(TERM_TOKEN)
            tok = ""
        elif tok == ENDTERM_TOKEN:
            tokens.append(ENDTERM_TOKEN)
            tok = ""
        elif tok == THEN_TOKEN:
            if expr != "" and not isexpr:
                tokens.append(colonToken(NUMBER_TOKEN) + expr)
                expr = ""
            tokens.append(THEN_TOKEN)
            tok = ""
        elif tok == INPUT_TOKEN:
            tokens.append(INPUT_TOKEN)
            tok = ""
        elif tok == "0" or tok == "1" or tok == "2" or tok == "3" or tok == "4" or tok == "5" or tok == "6" or tok == "7" or tok == "8" or tok == "9":
            expr += tok
            tok = ""
        elif tok == "+" or tok == "-" or tok == "/" or tok == "(" or tok == ")" or tok == "*":
            isexpr = True
            expr += tok
            tok = ""
        elif tok == "\"" or tok == " \"":
            if state == 0:
                state = 1
            elif state == 1:
                tokens.append(colonToken(STRING_TOKEN) + string + "\"")
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
    if toprint[0:6] == STRING_TOKEN:
        toprint = toprint[8:]
        toprint = toprint[:-1]
    elif toprint[0:3] == NUMBER_TOKEN:
        toprint = toprint[4:]
    elif toprint[0:4] == EXPRESSION_TOKEN:
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
        exit()

def outToken(tokenName):
    return PRINT_TOKEN + " " + tokenName

def colonToken(tokenName):
    return tokenName + ":"

def getInput(string, varName):
    i = input(string[1:-1] + " ")
    symbols[varName] = colonToken(STRING_TOKEN) + "\"" + i + "\""

def parse(toks):
    i = 0
    while i < len(toks):
        if toks[i] == ENDTERM_TOKEN:
            print("Found elif")
            i = i+1
        elif toks[i] + " " + toks[i + 1][0:6] == outToken(STRING_TOKEN) or \
                toks[i] + " " + toks[i + 1][0:3] == outToken(NUMBER_TOKEN) or \
                toks[i] + " " + toks[i + 1][0:4] == outToken(EXPRESSION_TOKEN) or \
                toks[i] + " " + toks[i + 1][0:3] == outToken(NUMBER_TOKEN) or \
                toks[i] + " " + toks[i + 1][0:3] == outToken(VARIABLE_TOKEN):
            if toks[i + 1][0:6] == STRING_TOKEN:
                doPrint(toks[i + 1])
            elif toks[i + 1][0:3] == NUMBER_TOKEN:
                doPrint(toks[i + 1])
            elif toks[i + 1][0:4] == EXPRESSION_TOKEN:
                doPrint(toks[i + 1])
            elif toks[i + 1][0:3] == VARIABLE_TOKEN:
                doPrint(getVARIABLE(toks[i+1]))
            i += 2
        elif toks[i][0:3] + " " + toks[i+1] + " " + toks[i+2][0:6] == "pet EQUALS string" \
                or toks[i][0:3] + " " + toks[i+1] + " " + toks[i+2][0:3] == "pet EQUALS num" \
                or toks[i][0:3] + " " + toks[i+1] + " " + toks[i+2][0:4] == "pet EQUALS expr" or \
                toks[i][0:3] + " " + toks[i+1] + " " + toks[i+2][0:3] == "pet EQUALS pet":
            if toks[i + 2][0:6] == STRING_TOKEN:
                doASSIGN(toks[i], toks[i+2])
            elif toks[i + 2][0:3] == NUMBER_TOKEN:
                doASSIGN(toks[i], toks[i+2])
            elif toks[i + 2][0:4] == EXPRESSION_TOKEN:
                doASSIGN(toks[i], colonToken(NUMBER_TOKEN) + str(evalExpression(toks[i+2][5:])))
            elif toks[i + 2][0:3] == VARIABLE_TOKEN:
                doASSIGN(toks[i], getVARIABLE(toks[i+2]))
            # print(toks[i+2])
            i += 3
        elif toks[i] + " " + toks[i+1][0:6] + " " + toks[i+2][0:3] == INPUT_TOKEN + " " + STRING_TOKEN + " " + VARIABLE_TOKEN:
            getInput(toks[i+1][7:], toks[i+2][4:])
            i += 3
        elif toks[i] + " " + toks[i+1][0:3] + " " + toks[i+2] + " " + toks[i+3][0:3] + " " + toks[i+4] == TERM_TOKEN + \
                " " + NUMBER_TOKEN + " " + IS_EQUALS_TOKEN + " " + NUMBER_TOKEN + " " + THEN_TOKEN:
            if toks[i+1][4:] == toks[i+3][4:]:
                print("True")
            else:
                print("False")
            i += 5

    print(symbols)


def run():
    data = open_file(argv[1])
    toks = lex(data)
    parse(toks)


run()
