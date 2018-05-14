#!/usr/bin/env node

/**
 * Module dependencies.
 */

var path = require('path'),
    pkg = require(path.join(__dirname, 'package.json')),
    fs = require('fs'),
    repl = require('repl'),
    escodegen = require('escodegen'),
    program = require('commander'),
    vm = require('vm'),
    parser = require('./lib/parser');

/**
 * Parse command line arguments
 */

program
    .version(pkg.version);

program
    .command('compile')
    .alias('comp')
    .description('compile pet code to ECMAScript')
    .option('-s, --source <path>', 'path to pet source file')
    .option('-o, --output <path>', 'path to ECMAScript output file')
    .action(function(options){
        if(!options.source){
            console.error('pet source file is required');
            program.outputHelp();
            return;
        } else if(path.extname(path.basename(options.source)) !== '.pet'){
            console.error('pet source files should have a .pet extension');
            return;
        }

        console.log('Attempting to compile pet code to JavaScript');

        fs.readFile(options.source, 'utf8', function(err, source){
            var parsed,
                ecma,
                result;

            try{
                parsed = parser.parse(source),
                ecma = escodegen.generate(parsed);
                options.output = options.output || options.source.replace('.pet', '.js');
                result = vm.runInNewContext(ecma, {}, {
                    displayErrors: false,
                    timeout: 10000
                });
                console.log('Successfully compiled pet code to JavaScript');
                console.log('Evaluation result: ' + result);
                fs.writeFile(options.output, ecma, 'utf8', function(err){
                    if(err){
                        console.log(err);
                    } else {
                        console.log('Output written to ' + options.output);
                    }
                });
            } catch(e){
                console.log('Failed to compile pet code to JavaScript');
                console.log(e);
            }
        });
    });

program
    .command('repl')
    .description('launch the pet CLI REPL utility')
    .action(function(options){
        var petREPL;

        console.log('Welcome to the pet REPL!');

        petREPL = repl.start({
            prompt: 'petc> ',
            eval: function eval(cmd, context, filename, callback){
                var parsed,
                    ecma,
                    result;

                try{
                    parsed = parser.parse(cmd);
                    ecma = escodegen.generate(parsed);
                    result = vm.runInNewContext(ecma, context, {
                        filename: filename,
                        displayErrors: false,
                        timeout: 10000
                    });
                } catch(e){
                    return callback(e);
                }
                
                callback(null, result);
            }
        });

        petREPL.on('exit', function () {
            console.log('pet bye!');
            process.exit();
        });
    });

console.log('pet CLI.');
program.parse(process.argv);