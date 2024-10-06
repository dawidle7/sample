const process = require('child_process');
var lines,linesf,liness;
const e=' -not -path "/dev/*" -a -not -path "/tmp/*" -a -not -path "/proc/*" -a -not -path "/sys/*" -a -not -path "/run/*" '

var stdout=process.execSync("dpkg -l --no-pager |awk '{print $2}'|awk -F ':' '{print $1}'");
lines = stdout.toString().split('\n');
lines=lines.slice(5);

let outputAssociativeArray = {};

lines.forEach((line) => {
    if (line.trim()) {
        stdout=process.execSync(`dpkg -L --no-pager ${line}`);
        linesf = stdout.toString().split('\n');
        linesf.forEach((linef) => {
            outputAssociativeArray[linef] = linef;
        });
        //console.log(`${line}`);
    }
}); 

//console.log(outputAssociativeArray);
stdout=process.execSync(`find /etc ${e} 2>/dev/null|| true`);
liness = stdout.toString().split('\n');

const set = new Set(Object.values(outputAssociativeArray));
const elementsNotInSet = liness.filter(element => !set.has(element));

console.log(elementsNotInSet);