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
function fibonacci(fba, fbc, n) {
    if (n > 0) {
        var currFib = fba + fbc;
        console.log(currFib);
        return fibonacci(currFib, fba, n - 1);
    } else {
        var currFib = fba + fbc;
        return currFib;
    }
}
var fb = 1;
var fib = 1;
var currentFib = 0;
for (var i = 0; i < 10; i = i + 1) {
    currentFib = fb + fib;
    fb = fib;
    fib = currentFib;
    console.log(currentFib);
}
var fibRec = fibonacci(1, 1, 5);
var p = 0;
do {
    p = p + 1;
    console.log(p);
} while (p < 10);