function sum(num) {
    console.log(num);
    if (num < 5) {
        return sum(num + 1);
    } else {
        return 6;
    }
}
var p = sum(0);
console.log(p);