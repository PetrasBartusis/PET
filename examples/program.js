function sum(num) {
    console.log(num);
    if (num < 5 & num > 3) {
        return sum(num + 1);
    } else {
        return 6;
    }
}
var p = sum(0);
p = Math.abs(p);
console.log(p);
console.log('CIKLAS:');
for (var a = 0; a < 10; a = a + 1) {
    var something = a * a;
    console.log(something);
}
console.log('a');
do {
    sum(0);
} while (false);