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