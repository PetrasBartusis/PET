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


