function sum(num) {
    console.log(num);
    ;
    if (num < 5) {
        return sum(num + 1);
    } else {
        return 6;
    }
}
var p = sum(0);
console.log(p);
;
console.log('CIKLAS:');
for (var a = 0; a < 10; a++) {
    var something = a * a;
    console.log(something);
    ;
}
console.log('a');