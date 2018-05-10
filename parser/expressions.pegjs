


 
	
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

	  