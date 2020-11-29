#1. Написать процедуру, которая добавляет связанные данные в несколько
#таблиц. В том случае, если вставка данных в одну из таблиц по какой-либо
#причине невозможна, выполняется откат внесенных процедурой изменений.
use sakila;

drop procedure if exists add_city_country ;

delimiter $$
create procedure add_city_country(in arg_country_id smallint , in arg_country varchar(50) , in arg_city_id smallint , in agr_city varchar(50) , in agr_country_id smallint )
begin
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
		ROLLBACK;
		signal sqlstate '45000' set message_text = 'foriend key error';
	END;
	START TRANSACTION;
    if  arg_country_id<0 or length(arg_country)=0 then
		rollback;
	else
		INSERT INTO country(country_id,country,last_update) VALUE (arg_country_id, arg_country , current_timestamp());
	end if;
      if  arg_city_id<0 or length(agr_city)=0 or agr_country_id<0 then
		rollback;
	else
		INSERT INTO city(city_id,city,country_id,last_update) VALUE (arg_city_id,agr_city,agr_country_id,current_timestamp());	
	end if;
	COMMIT;
end$$
delimiter ;

#2. Написать процедуру, которая добавляет в таблицу несколько строк данных.
#При каждом добавлении строки выполняется проверка выполнимости
#некоторого условия на агрегированных данных одного из столбцов данной
#таблицы (например, сумма всех значений по заданному столбцу не
#превышает заданного значения). При невыполнении данного условия
#выполняется откат добавления такой строки (используя оператор ROLLBACK
#TO SAVEPOINT).
use football_league;

drop procedure if exists add_cash ;

delimiter $$
create procedure add_cash(IN arg_max int)
begin
	DECLARE done INT DEFAULT TRUE;
	DECLARE tmp INT DEFAULT 0;
	start transaction;
		while done do 
        savepoint ret;
        insert into budget(cash) value(1000);
		set tmp =( select sum(b.cash) from budget b  );
        if tmp > arg_max then
			rollback to savepoint ret;
            set done =false ;
		end if ;
        end while;
        release savepoint ret;
        commit;
end$$
delimiter ;



#3. Продемонстрировать возможность чтения незафиксированных изменений
#при использовании уровня изоляции READ UNCOMMITTED и отсутствие
#такой возможности при уровне изоляции READ COMMITTED.

#4. Продемонстрировать возможность записи в уже прочитанные данные при
#использовании уровня изоляции READ COMMITTED и отсутствие такой
#возможности при уровне изоляции REPEATABLE READ. Для этого создать
#две процедуры, одна из процедур в цикле выполняет запись в таблицу,
#другая – чтение данных из этой таблицы.

#5. Продемонстрировать возможность фантомного чтения при использовании
#уровня изоляции READ COMMITTED и отсутствие такой возможности при
#уровне изоляции REPEATABLE READ.

