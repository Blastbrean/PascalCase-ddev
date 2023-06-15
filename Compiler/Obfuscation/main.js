import luamin from 'luamin';
import luaparse from 'luaparse';
import fs from 'fs';

export default function obfuscate_string(string) {
    // minify string to remove variable names and more
    string = luamin.minify(string);

    // parse string
    const ast = luaparse.parse(string);
    fs.writeFile('test.json', JSON.stringify(ast, null, 4), function() {});  

    return string;
}
