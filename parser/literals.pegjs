

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

