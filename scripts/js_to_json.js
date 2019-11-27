#!/Users/soxley/.nvm/versions/node/v10.15.0/bin/node

process.stdin.setEncoding('utf8');
process.stdin.on('readable', function () {
  const data = this.read();
  if (data) {
    let x;
    eval(`x = ${data}`);
    console.log(JSON.stringify(x, null, 2));
  }
});
