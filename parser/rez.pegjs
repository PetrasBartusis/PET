{
  function convertFromLietuviskasToJS(operators) {
		return operators.map((o) => {
      switch (o) {
        case 'daugiau':
          return '>'
        case 'maziau':
          return '<'          
        case 'lygu':
          return '='          
        case 'sudėti':
          return '+'          
        case 'atimti':
          return '-'          
        case 'dauginti':
          return '*'          
        case 'dalinti':
          return '/'          
        default:
          return o;
      }
		}).join('');
	}

  function optionalList(value) {
   return value !== null ? value : [];
  }

  function buildList(first, rest, index) {
    return [first].concat(extractList(rest, index));
  }

  function extractList(list, index) {
    var result = new Array(list.length), i;

    for (i = 0; i < list.length; i++) {
      result[i] = list[i][index];
    }

    return result;
  }

  function filledArray(count, value) {
    var result = new Array(count), i;

    for (i = 0; i < count; i++) {
      result[i] = value;
    }

    return result;
  }

  function extractOptional(optional, index) {
    return optional ? optional[index] : null;
  }
}


start =
   __ program:Program __ { return program; }

Program =
  body:SourceElements? {
      return {
       type: "Program",
       body: optionalList(body)
      };
   }

SourceElements
  = first:SourceElement rest:(__ SourceElement)* {
      return buildList(first, rest, 1);
    }


FunctionParameterList =
    head:FunctionParameter tail:(__ "," __ FunctionParameter)* {
       var result = [head];
       for (var i = 0; i < tail.length; i++) {
          result.push(tail[i][3]);
       }
       return result;
    }

FunctionParameter =
    type:Type _ name:Identifier {
       return {
          type: "Identifier",
          name: name['name']
       }
    }

FunctionDeclaration =
     "veiksmas" __ id:Identifier __
     "(" __ params:FunctionParameterList? __ ")" __
     "{" __ body:FunctionBody __ "}" {
		return {
			type: "FunctionDeclaration",
			id: id,
			params: optionalList(params),
			body: optionalList(body)
	}
	}

FunctionBody
  = body:SourceElements? {
      return {
        type: "BlockStatement",
        body: optionalList(body)
      };
    }

Identifier =
    !(ReservedWord [ (]+) beginning:[_A-Za-z] rest:[_A-Za-z0-9]* {
      return {
		  type: "Identifier",
		  name: beginning+rest.join("")
	  }
    }

FunctionTypedParameterList =
    head:FunctionTypedParameter tail:(__ "," __ FunctionTypedParameter)* {
       var result = [head];
       for (var i = 0; i < tail.length; i++) {
          result.push(tail[i][3]);
       }
       return result;
    }
	
    FunctionTypedParameter =
     id: Identifier
	/ val: Literal

Brackets =
	"(" expression:BinaryExpression ")" {
		return expression;
	}

InitialiserInt
    = "priskirti" !"priskirti" __ expression:DigitLiteral { return expression; }

InitialiserBool
    = "priskirti" !"priskirti" __ expression:BooleanLiteral { return expression; }
	
Initialiser
    = "priskirti" !"priskirti" __ expression:BinaryExpression { return expression; }	

Type =
  "sveikasis"
  / "arTiesa"

WhiteSpace "whitespace"
   = "\t"
   / "\v"
   / "\f"
   / " "
   / "\u00A0"
   / "\uFEFF"


LineTerminator
 = [\n\r\u2028\u2029]

LineTerminatorSequence "end of line"
 = "\n"
 / "\r\n"
 / "\r"
 / "\u2028"
 / "\u2029"
 / ";"

Operator =
	"dauginti" !"lygu"
	/ "dalinti" !"lygu"
    /"sudėti" !"lygu"
	/ "atimti" !"lygu"
	/ "daugiau" ("lygu")?
	/ "mažiau"  ("lygu")?
	/ "lygu" "lygu"
	/ "ne" "lygu"

Keyword =
	"grąžink"
	/ "kol"
	/ "jeigu"
	/ "veiksmas"

__ =
   (WhiteSpace / LineTerminatorSequence)*
   
_ = WhiteSpace+
   

Literal =
	DigitLiteral
    / BooleanLiteral
    / MemberExpression

Expression
  = Literal
  / Identifier
  / MemberExpression
  / Brackets

  ReservedWord = 
  Keyword
	/ DigitLiteral
	/ BooleanLiteral
    / Type

    
SourceElement
  = FunctionDeclaration
  / Statement


Statement
  = VariableStatement
  	/ CallExpression
	/ ExpressionStatement
	/ IfStatement
	/ WhileStatement
	/ ReturnStatement

EOF
  = !.

    BooleanLiteral "arTiesa" =
	"tiesa" {
		return {
			type: "Literal",
			value: true
		}
	}
	/"melas" {
		return {
			type: "Literal",
			value: false
		}
	}
    
DigitLiteral "sveikasis" = 
	first:([1-9]) val:([0-9]*) !"." {
		return {
			type: "Literal",
			value: Number(first+val.join(""))
		}
	}
	/ first: [0] {
		return {
			type: "Literal",
			value: Number(first)
		}
	}




 
	
	BinaryExpression
	= 
	 left: Expression _?
	  operator: Operator _?
	  right: BinaryExpression {
		  return {
  			type: "BinaryExpression",
  			operator: convertFromLietuviskasToJS(operator),
  	FunctionTypedParameterList		left: left,
  			right: right
		  }
	  }
	/ left: CallExpression _?
	  operator: Operator _?
	  right: BinaryExpression {
		  return {
  			type: "BinaryExpression",
  			operator: convertFromLietuviskasToJS(operator),
  			left: left,
  			right: right
		  }
	  }
	/ left: MemberExpression _?
	  operator: Operator _?
	  right: BinaryExpression {
		  return {
  			type: "BinaryExpression",
  			operator: convertFromLietuviskasToJS(operator),
  			left: left,
  			right: right
		  }
	  }

	/ right: CallExpression
	/ right: Expression
	/ right: MemberExpression
	
MemberExpression
	= id:Identifier "[" _? index:Expression _? "]"  {
		return {
			type: "MemberExpression",
			object: id,
			property: index,
			computed: true
		}	
	}

    	
CallExpression
	= id:Identifier "(" __ params:FunctionTypedParameterList? __ ")" __ {
	 return {
		 type: "CallExpression",
		 callee: id,
		 arguments: optionalList(params)
	 }
 }

 AssignmentExpression
	= id:Identifier init:(_ Initialiser) {
		return {
			type: "AssignmentExpression",
			operator: "priskirti",
			left: id,
			right: extractOptional(init, 1)
		};
	}
	/ id:MemberExpression init:(_ Initialiser) {
  		return {
  			type: "AssignmentExpression",
			operator: "priskirti",
  			left: id,
  			right: extractOptional(init, 1)
  		};
	  }

	  VariableStatement
  = 'sveikasis' _ id:Identifier init:(_ InitialiserInt)? {
      return {
      type:         "VariableDeclaration",
      declarations: [{
			type: "VariableDeclarator",
			id: id,
			init: extractOptional(init, 1)
		}],
	  kind: "var"
      };
    }
    /t:Type _ id:Identifier init:(_ Initialiser)? {
      return {
      type:         "VariableDeclaration",
      declarations: [{
			type: "VariableDeclarator",
			id: id,
			init: extractOptional(init, 1)
		}],
	  kind: "var"
      };
    }

ExpressionStatement
	= expression:AssignmentExpression {
		return {
			type: "ExpressionStatement",
			expression: expression
		};
	}
	/ expression:MemberExpression {
  		return {
  			type: "ExpressionStatement",
			expression: expression
  		};
	  }
	/ expression:BinaryExpression {
		return {
			type: "ExpressionStatement",
			expression: expression
		}
	}

IfStatement
  = "jeigu" _? "(" __ test:BinaryExpression __ ")" __
	"{" __ consequent:FunctionBody? __ "}" __
    "kitaip" __ "{" __ alternate:FunctionBody __ "}" __
    {
      return {
        type:       "IfStatement",
        test:       test,
        consequent: consequent,
        alternate:  alternate
      };
    }
  / "jeigu" _? "(" __ test:BinaryExpression __ ")" __
	"{" __ consequent:FunctionBody? __ "}" __
    {
      return {
        type:       "IfStatement",
        test:       test,
        consequent: consequent,
        alternate:  null
      };
    }
	
WhileStatement
  = "kol" _? "(" __ test:BinaryExpression __ ")" __
	"{" __ body:FunctionBody? __ "}" __
    {
      return {
        type: "WhileStatement",
        test: test,
        body: body
      };
    }

ReturnStatement =
	"grąžink" __ expression:BinaryExpression? __ {
		return {
			type: "ReturnStatement",
			argument: expression
		}
	}

	