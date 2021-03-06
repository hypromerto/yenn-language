%{
    #include <stdio.h>
    int yylex();
    void yyerror(char *s);
%}

%token START
%token FINISH
%token IF
%token ELSE
%token BLOCK_START
%token BLOCK_FINISH
%token FOR
%token IN
%token WHERE
%token WITH
%token WHILE
%token FUNC
%token CALL
%token RETURN
%token READ_TEMP
%token READ_HUMIDITY
%token READ_AIR_PRESSURE
%token READ_AIR_QUALITY
%token READ_LIGHT
%token READ_SOUND_LEVEL
%token READ_TIMER
%token SEND_INT
%token READ_INT
%token CONNECT
%token SCAN
%token PRINT
%token SWITCH_ON_1
%token SWITCH_ON_2
%token SWITCH_ON_3
%token SWITCH_ON_4
%token SWITCH_ON_5
%token SWITCH_ON_6
%token SWITCH_ON_7
%token SWITCH_ON_8
%token SWITCH_ON_9
%token SWITCH_ON_10
%token SWITCH_OFF_1
%token SWITCH_OFF_2
%token SWITCH_OFF_3
%token SWITCH_OFF_4
%token SWITCH_OFF_5
%token SWITCH_OFF_6
%token SWITCH_OFF_7
%token SWITCH_OFF_8
%token SWITCH_OFF_9
%token SWITCH_OFF_10
%token INTEGER
%token DOUBLE_VALUE
%token STRING_TEXT
%token COMMENT_TEXT
%token ARRAY
%token INT
%token STRING
%token DOUBLE
%token CONNECTION
%token LP
%token RP
%token LSB
%token RSB
%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE
%token COMMA
%token AND
%token OR
%token IDENTIFIER
%token LESS
%token GREATER
%token LESS_EQ
%token GREATER_EQ
%token EQ
%token EQ_COMP
%token POW

%start program

%%

program : START stmts FINISH 

stmts : stmts stmt | stmt

stmt : matched_stmt | unmatched_stmt

matched_stmt : IF LP expression RP matched_stmt ELSE matched_stmt | non_if_stmt | loop_stmt matched_stmt

unmatched_stmt : IF LP expression RP stmt
        | IF LP expression RP matched_stmt ELSE unmatched_stmt | loop_stmt unmatched_stmt

non_if_stmt : assign_stmt | var_declaration | COMMENT_TEXT | func_call_stmt | func_declaration | return_stmt | control_switches | code_block

code_block : BLOCK_START non_if_stmt_list BLOCK_FINISH

non_if_stmt_list : non_if_stmt_list stmt | stmt

assign_stmt : lside EQ rside

rside : expression

lside : IDENTIFIER | var_declaration 

expression : or_expression

or_expression : or_expression OR and_expression | and_expression

and_expression : and_expression AND comparison_expression | comparison_expression

comparison_expression : comparison_expression comparator add_sub_expression | add_sub_expression

add_sub_expression : add_sub_expression PLUS  mul_div_expression | add_sub_expression MINUS mul_div_expression | mul_div_expression

mul_div_expression : mul_div_expression MULTIPLY pow_expression | mul_div_expression DIVIDE pow_expression | pow_expression

pow_expression : pow_expression POW element | element

element : LP expression RP | IDENTIFIER | INTEGER | DOUBLE_VALUE | array_init | STRING_TEXT  | func_call_stmt

array_init :  LSB array_elements RSB

array_elements : array_elements COMMA array_element | array_element

array_element : INTEGER | DOUBLE_VALUE | STRING_TEXT | IDENTIFIER

var_declaration : type_id IDENTIFIER | ARRAY IDENTIFIER

func_declaration :  FUNC IDENTIFIER LP parameter_list RP | FUNC IDENTIFIER LP RP

loop_stmt : for_stmt | while_stmt

for_stmt : FOR LP IDENTIFIER IN IDENTIFIER RP  | FOR LP assign_stmt WHERE expression WITH assign_stmt RP  | FOR LP assign_stmt WHERE expression RP

while_stmt : WHILE LP expression RP  

func_call_stmt : primitive_func_call | non_primitive_func_call

primitive_func_call : read_temp | read_hum | read_air_p | read_air_q | read_light | read_sound_lvl | read_timestamp_from_timer | send_integer_to_connection | read_integer_from_connection | connect | scan | print

non_primitive_func_call : CALL IDENTIFIER LP parameter_list_on_call RP | CALL IDENTIFIER LP RP

parameter_list_on_call : rside |  parameter_list_on_call COMMA rside

return_stmt : RETURN IDENTIFIER | RETURN DOUBLE_VALUE | RETURN INTEGER | RETURN STRING_TEXT | RETURN array_init

parameter_list : var_declaration | parameter_list COMMA var_declaration

scan : SCAN LP RP  | SCAN LP STRING_TEXT RP

print : PRINT LP IDENTIFIER RP | PRINT LP INTEGER RP | PRINT LP STRING_TEXT  RP | PRINT LP DOUBLE_VALUE RP | PRINT LP array_init RP

read_temp : READ_TEMP LP RP

read_hum : READ_HUMIDITY LP RP

read_air_p : READ_AIR_PRESSURE LP RP

read_air_q : READ_AIR_QUALITY LP RP

read_light : READ_LIGHT LP RP

read_sound_lvl : READ_SOUND_LEVEL LP DOUBLE_VALUE RP | READ_SOUND_LEVEL LP IDENTIFIER RP

read_timestamp_from_timer : READ_TIMER LP RP

send_integer_to_connection : SEND_INT LP IDENTIFIER COMMA IDENTIFIER RP | SEND_INT LP IDENTIFIER COMMA INTEGER RP

read_integer_from_connection : READ_INT LP IDENTIFIER RP

connect : CONNECT LP IDENTIFIER RP | CONNECT LP STRING_TEXT RP

control_switches : turn_on | turn_off

turn_on : SWITCH_ON_1 | SWITCH_ON_2 | SWITCH_ON_3 | SWITCH_ON_4 | SWITCH_ON_5 | SWITCH_ON_6 | SWITCH_ON_7 | SWITCH_ON_8 | SWITCH_ON_9 | SWITCH_ON_10

turn_off : SWITCH_OFF_1 | SWITCH_OFF_2 | SWITCH_OFF_3 | SWITCH_OFF_4 | SWITCH_OFF_5 | SWITCH_OFF_6 | SWITCH_OFF_7 | SWITCH_OFF_8 | SWITCH_OFF_9 | SWITCH_OFF_10

type_id : INT | DOUBLE | STRING | CONNECTION

comparator : GREATER | LESS  | GREATER_EQ | LESS_EQ | EQ_COMP
%%


#include "lex.yy.c"
extern int lineCount;
int check = 0;
void yyerror(char *s)
{
    printf ("%s on line %d\n", s, lineCount);
    check = 1;
}

int main(void)
{
    yyparse();
    if ( check == 0 )
    {
        printf ("Input program is valid\n");
    }
}