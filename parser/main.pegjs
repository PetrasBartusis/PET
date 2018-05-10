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

