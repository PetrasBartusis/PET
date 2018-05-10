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

	