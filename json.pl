parse(String, Data) :-
    atom_chars(String, Chars),
    phrase(json(Data), Chars).

json(String) --> json_string(String).
json(Number) --> json_number(Number).
json(Bool) --> json_bool(Bool).
json(Null) --> json_null(Null).
json(Array) --> json_array(Array).
json(Object) --> json_object(Object).

json_string(String) --> ['"'], json_chars(Chars), ['"'], { atom_chars(String, Chars) }.

json_chars([]) --> [].
json_chars([Char|Chars]) --> [Char], { Char \= '"' }, json_chars(Chars).

json_number(Number) --> json_digits(Digits), { number_chars(Number, Digits) }.
json_digits([Digit|Digits]) --> json_digit(Digit), json_digits(Digits).
json_digits([Digit]) --> json_digit(Digit).
json_digit(Digit) --> [Digit], { code_type(Digit, digit) }.

json_bool(true) --> ['t','r','u','e'].
json_bool(false) --> ['f','a','l','s','e'].

json_null(null) --> ['n','u','l','l'].

json_array(Array) --> ['['], json_values(Array), [']'].

json_values([Value|Values]) --> json(Value), [','], json_values(Values).
json_values([Value]) --> json(Value).

json_object(Object) --> ['{'], json_pairs(Object), ['}'].
json_pairs([Pair|Pairs]) --> json_pair(Pair), [','], json_pairs(Pairs).
json_pairs([Pair]) --> json_pair(Pair).
json_pair(Key=Value) --> json_string(Key), [':'], json(Value).

