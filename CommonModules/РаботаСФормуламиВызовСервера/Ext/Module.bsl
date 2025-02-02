﻿
#Область ПрограммныйИнтерфейс

// Функция формирует пустое дерево операторов.
// 
Функция ПолучитьПустоеДеревоОператоров() Экспорт
	
	Дерево = Новый ДеревоЗначений();
	Дерево.Колонки.Добавить("Наименование");
	Дерево.Колонки.Добавить("Оператор");
	Дерево.Колонки.Добавить("Сдвиг", Новый ОписаниеТипов("Число"));
	
	Возврат Дерево;
	
КонецФункции

// Функция добавляет группу операторов в строки дерева.
// 
Функция ДобавитьГруппуОператоров(Дерево, Наименование) Экспорт
	
	НоваяГруппа = Дерево.Строки.Добавить();
	НоваяГруппа.Наименование = Наименование;
	
	Возврат НоваяГруппа;
	
КонецФункции

// Функция добавляет оператор в строки дерева
// или в строки строки дерева.
Функция ДобавитьОператор(Дерево, Родитель, Наименование, Оператор = Неопределено, Сдвиг = 0) Экспорт
	
	НоваяСтрока = ?(Родитель <> Неопределено, Родитель.Строки.Добавить(), Дерево.Строки.Добавить());
	НоваяСтрока.Наименование = Наименование;
	НоваяСтрока.Оператор = ?(ЗначениеЗаполнено(Оператор), Оператор, Наименование);
	НоваяСтрока.Сдвиг = Сдвиг;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Функция формирует стандартное дерево операторов.
// 
Функция ПолучитьСтандартноеДеревоОператоров() Экспорт
	
	Дерево = ПолучитьПустоеДеревоОператоров();
	ГруппаОператоров = ДобавитьГруппуОператоров(Дерево, "Операторы");
	ДобавитьОператор(Дерево, ГруппаОператоров, "+", " + ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "-", " - ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "*", " * ");
	ДобавитьОператор(Дерево, ГруппаОператоров, "/", " / ");
	
	Возврат Дерево;
	
КонецФункции

// Функция получает результат вычисления
// по заданному тексту формулы.
Функция ВычислитьФормулу(ТекстРасчета) Экспорт
	
	Возврат Вычислить(ТекстРасчета);
	
КонецФункции

#КонецОбласти
