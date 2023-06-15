import { bundle } from 'luabundle'
import { writeFile } from 'fs/promises';
import { format } from 'util';

import chokidar from 'chokidar';
import obfuscate_string from './Obfuscation/main.js';

// messy, only used for fast development so i didn't pay much care to the design of this tool.
const watch_for_changes = '../';
const main_path = '../Main.lua';
const output_path = 'Output.lua';
const should_obfuscate = true;

async function main( path, out_path ) {
    try {
        var out = bundle(path, {
            metadata: false,
            luaVersion: "5.1"
        });
        
        if (should_obfuscate) {
            out = obfuscate_string(out);
        }

        if ( out ) {
            await writeFile(out_path, out);
        }

        console.log(format("compiler: finished -> %s", out_path));
    } catch ( error ) {
        console.log(error);
        console.log("compiler: an error was encountered. compilation was stopped.");
    }    
}

async function run( ) {
    await main(main_path, output_path);  
    
    console.log("compiler: watching for file changes...");

    const watcher = chokidar.watch(watch_for_changes, {
        persistent: true,
      
        ignored: ['*.js', output_path],
        ignoreInitial: false,
        followSymlinks: true,
        cwd: '.',
        disableGlobbing: false,
      
        usePolling: false,
        interval: 100,
        binaryInterval: 300,
        alwaysStat: false,
        depth: 99,
        awaitWriteFinish: {
          stabilityThreshold: 2000,
          pollInterval: 100
        },
      
        ignorePermissionErrors: false,
        atomic: true // or a custom 'atomicity delay', in milliseconds (default 100)
    });

    watcher.on('change', path => {
        const re = /(?:\.([^.]+))?$/;
        const ext = re.exec(path)[1]; 
        if (ext != "lua") {
            return;
        }

        if (path == output_path) {
            return;
        }

        console.log(format("compiler: hot-reload! compiling -> found changes in %s", path));
        main(main_path, output_path);
    });
}

run( );
