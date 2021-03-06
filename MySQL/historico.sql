# remoção da ocorrência de cancelamento de disciplina para evitar comprometimento da análise
#delete from historico
#where observacao = 'cancelado';

# adição da informação 'aproveitamento' na coluna de observação para disciplinas com reprovação sem frequência
#update historico
#set observacao = 'Aproveitamento'
#where situacao = 'reprovado' and frequencia = '';

#Obtenção de dados:

/*
#1. Total de disciplinas realizadas:
SELECT * FROM historico;
#89 ocorrências considerando disciplinas realizadas mais de uma vez por conta de reprovação
	
select * from historico
where situacao = 'aprovado';
#81 ocorrências. remoção de disciplinas repetidas por conta de reprovação
*/

/*
#2. Carga horária total
select sum(ch) from historico;
# 4905 horas. são consideradas horas

select sum(ch) from historico
where observacao != 'aproveitamento';
#4740 horas. remoção de carga horária de disciplinas realizadas por prova de aproveitamento
*/

/*
#3. carga horária por semestre
select periodo, sum(ch) from historico
where observacao != 'aproveitamento'
group by periodo;
# 1 = 480, 2 = 465, 3 = 525, 4 = 420, 5 = 480, 6 = 420, 7 = 510, 8 = 495, 9 = 480, 10 = 120, 11 = 45, 12 = 300
*/

/*
#4. média de nota total
select avg(nota) from historico;
#68.2135
*/
/*
#5.média de nota por semestre com 2 casas decimais
select periodo, round(avg(nota), 2) from historico
group by periodo;
# 1 = 70.50, 2 = 72.13, 3 = 69.78, 4 = 66.00, 5 = 48.78, 6 = 65.88, 7 = 70.82, 8 = 65.50, 9 = 73.56, 10 = 100.00, 11 = 100.00, 12 = 87.00
*/


#6. média de frequência total
#select round(avg(frequencia), 2) from historico;

/*
#7. média de frequência por semestre
select periodo, round(avg(frequencia), 2) from historico
group by periodo;
*/

/*
#8. disciplinas com maiores notas. limite 5 disciplinas
select * from historico
order by nota desc
limit 5;
*/

/*
#9. disciplinas com menores notas. limite 5 disciplinas
select * from historico
order by nota
limit 5;
*/

/*
#10. disciplinas com maiores frequências. limite 5 disciplinas
select *,
frequencia * 1 as freq from historico
order by freq desc
limit 5;
#durante a importação a frequência ficou como dado do tipo texto, a multiplicação por 1 passa para formato int, corrigindo a ordenação dos valores 
*/
/*
#11. disciplinas com menores frequencias. limite 5 disciplinas
select *, frequencia * 1 as freq
from historico
having freq <75
order by freq;
#listando adicionando o filtro de 75% de presença, valor mínimo para aprovação em disciplina
*/

/*
#13. Número de reprovações
select 
count(*) as 'reprovações'
from historico
where situacao = 'reprovado';
#8 ocorrências
*/

/*
#14. número de optativas
select
count(*) as 'optativas'
from historico
where Observacao = 'optativa'
# 8 ocorrências
*/

/*
#15 adicionar coluna contendo departamento
alter table historico
add Departamento varchar(50);

select * from historico;

UPDATE historico
    SET departamento = (case 
		when codigo regexp '^AE|^HC' then 'Economia e Extensão' 
		when codigo regexp '^AF' then 'Fitotecnia e Fitossanitarismo'
        when codigo regexp '^AL' then 'Solos'
        when codigo regexp '^AGRO' then 'Formativas'
        when codigo regexp '^AF' then 'Fitotecnia e Fitossanitarismo'
        when codigo regexp '^AS|^CE|^CI|^CQ|^CM|^CF|^GA|^GC' then 'Exatas'
        when codigo regexp '^B' then 'Biológicas'
        when codigo regexp '^AZ' then 'Zootecnia'
                    end);
select * from historico;
*/

/*
#16. avaliar desempenho (média nota) por departamento
select
round(avg(nota), 2) as media_depto,
departamento
from historico
group by departamento
order by media_depto desc;
*/

# Criar View com tabela sem as reprovações
create view tabela_aprovacoes as
select * from historico
where situacao = 'aprovado';