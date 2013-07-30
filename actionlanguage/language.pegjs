start = ws* statements: statement* ws* { return (statements); } 

whitespace
  = [' '\t\r\n]
ws = whitespace

identifier = id:id sub:(ws* "." ws* (operation:operation / sub_id:identifier))? {return {id:id, sub: sub[3] ? sub[3] : null}}

id = chars: ([a-zA-Z_]+[a-z-A-Z_0-9]*) { console.log(chars[0].concat(chars[1])); return chars[0].concat(chars[1]).join(""); }

expression = expressionLevel1

// lowest precedence, i.e. add and subtract
expressionLevel1 = 
    left:expressionLevel2 ws* operator:("+"/"-") ws* right: expression 
    {return {type: "expression", left:left, right:right, operator:operator}} 
    / expressionLevel2
    
// second-lowest precedence, i.e. multiply and divide
expressionLevel2 = 

    left:expressionLevel3 ws* operator:("*"/"/") ws* right: expressionLevel2 
    {return {type: "expression", left:left, right:right, operator:operator}} 
    / expressionLevel3

expressionLevel3 = 
    primary

operation = 
    (kw:keyword ws* "(" arguments:(ws* identifier ws* "=>" ws* expression )? ")") {return {kw:kw, iterator:arguments[1], expression: arguments[5]}}


statement = target:identifier ws* "=" ws* source:expression ws* ";" ws* {return {type: "assignment", target: target, source: source};}

primary = identifier / number / "(" ws* expression ws*")"

keyword = "map" / "each" / "sum"

number "number"
  = integral:('0' / [1-9][0-9]*) fraction:("." [0-9]*)? !([0-9A-Za-z]) {
  if (fraction && fraction.length) {
    fraction = fraction[0] + fraction[1].join('');
  } else {
    fraction = '';
  }

  integral = integral instanceof Array ?
    integral[0] + integral[1].join('') :
    '0';

  return parseFloat(integral + fraction);
}
        / ("." / "0.") fraction:[0-9]+
{
  return parseFloat("0." + fraction.join(''));
}