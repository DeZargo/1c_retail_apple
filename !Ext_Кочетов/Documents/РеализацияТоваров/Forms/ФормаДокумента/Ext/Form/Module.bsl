﻿
&НаКлиенте
Процедура КочетовЗаполнитьПоЦенамЗакупаСНаценкойВ10ПроцентовПеред(Команда)
	КочетовЗаполнитьПоЦенамЗакупаСНаценкойВ10ПроцентовПередНаСервере();	
	Для каждого стр из Объект.товары цикл
		ТекущаяСтрока = стр;
				
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ОбработкаТабличнойЧастиТоварыКлиент.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект));
		СтруктураДействий.Вставить("ПересчитатьСумму");
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Ложь));
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомАвтоматическойСкидки", Новый Структура("Очищать", Истина));
		
		ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(Объект.Товары, ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ЗаполнитьСуммуВсегоВСтрокеТаблицы(ТекущаяСтрока, Объект.ЦенаВключаетНДС);
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ОбновитьСуммыПодвала(Объект.Товары, Объект.ЦенаВключаетНДС, СуммаВсего);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура КочетовЗаполнитьПоЦенамЗакупаСНаценкойВ10ПроцентовПередНаСервере()
	Запрос=Новый запрос;
	мас=Новый массив;
	Для каждого стр из Объект.Товары Цикл
		мас.Добавить((стр.номенклатура.ххх_ИдЦентр));
	КонецЦикла;
	Запрос.УстановитьПараметр("мас",мас);
	Запрос.Текст="ВЫБРАТЬ
	             |	dbo_Tovar.id КАК id,
	             |	dbo_Tovar.cenZ КАК cenZ
	             |ИЗ
	             |	ВнешнийИсточникДанных.Пикник23.Таблица.dbo_Tovar КАК dbo_Tovar
	             |ГДЕ
	             |	dbo_Tovar.id В(&мас)";
	тз=Запрос.Выполнить().Выгрузить();	
	Запрос.УстановитьПараметр("тз",тз);
	Запрос.УстановитьПараметр("Закуп",справочники.ххх_Справочник.ЗакупочнаяЦена.значение);
	Запрос.Текст="ВЫБРАТЬ
	             |	тз.id КАК id_tov,
	             |	тз.cenZ КАК cenZ
	             |ПОМЕСТИТЬ qwe
	             |ИЗ
	             |	&тз КАК тз
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	id_tov
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	qwe.cenZ КАК cenZ,
	             |	Номенклатура.Ссылка КАК Ссылка
	             |ПОМЕСТИТЬ ТоварСоСмаркета
	             |ИЗ
	             |	qwe КАК qwe
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	             |		ПО qwe.id_tov = Номенклатура.ххх_ИдЦентр
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Номенклатура, ТоварСоСмаркета.Ссылка) КАК номка,
	             |	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, ТоварСоСмаркета.cenZ) КАК цена
	             |ИЗ
	             |	ТоварСоСмаркета КАК ТоварСоСмаркета
	             |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	             |				,
	             |				Номенклатура.ххх_ИдЦентр В (&мас)
	             |					И ВидЦены = &закуп) КАК ЦеныНоменклатурыСрезПоследних
	             |		ПО ТоварСоСмаркета.Ссылка = ЦеныНоменклатурыСрезПоследних.Номенклатура";
	выборка=запрос.Выполнить().Выбрать();

	Пока выборка.Следующий() Цикл
		строки=Объект.Товары.НайтиСтроки(Новый структура("номенклатура",выборка.номка));
		Для каждого стр из строки цикл
			стр.цена=выборка.цена+выборка.цена*0.1;
		КонецЦикла;
	КонецЦикла;
				 
				 
КонецПроцедуры

&НаСервере
Процедура КочетовЗаполнитьЗакупПередНаСервере()
		Запрос=Новый запрос;
	мас=Новый массив;
	Для каждого стр из Объект.Товары Цикл
		мас.Добавить((стр.номенклатура.ххх_ИдЦентр));
	КонецЦикла;
	Запрос.УстановитьПараметр("мас",мас);
	Запрос.Текст="ВЫБРАТЬ
	             |	dbo_Tovar.id КАК id,
	             |	dbo_Tovar.cenZ КАК cenZ
	             |ИЗ
	             |	ВнешнийИсточникДанных.Пикник23.Таблица.dbo_Tovar КАК dbo_Tovar
	             |ГДЕ
	             |	dbo_Tovar.id В(&мас)";
	тз=Запрос.Выполнить().Выгрузить();	
	Запрос.УстановитьПараметр("тз",тз);
	Запрос.УстановитьПараметр("Закуп",справочники.ххх_Справочник.ЗакупочнаяЦена.значение);
	Запрос.Текст="ВЫБРАТЬ
	             |	тз.id КАК id_tov,
	             |	тз.cenZ КАК cenZ
	             |ПОМЕСТИТЬ qwe
	             |ИЗ
	             |	&тз КАК тз
	             |
	             |ИНДЕКСИРОВАТЬ ПО
	             |	id_tov
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	qwe.cenZ КАК cenZ,
	             |	Номенклатура.Ссылка КАК Ссылка
	             |ПОМЕСТИТЬ ТоварСоСмаркета
	             |ИЗ
	             |	qwe КАК qwe
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	             |		ПО qwe.id_tov = Номенклатура.ххх_ИдЦентр
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Номенклатура, ТоварСоСмаркета.Ссылка) КАК номка,
	             |	ЕСТЬNULL(ЦеныНоменклатурыСрезПоследних.Цена, ТоварСоСмаркета.cenZ) КАК цена
	             |ИЗ
	             |	ТоварСоСмаркета КАК ТоварСоСмаркета
	             |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	             |				,
	             |				Номенклатура.ххх_ИдЦентр В (&мас)
	             |					И ВидЦены = &закуп) КАК ЦеныНоменклатурыСрезПоследних
	             |		ПО ТоварСоСмаркета.Ссылка = ЦеныНоменклатурыСрезПоследних.Номенклатура";
	выборка=запрос.Выполнить().Выбрать();
	
	
	
	Пока выборка.Следующий() Цикл
		строки=Объект.Товары.НайтиСтроки(Новый структура("номенклатура",выборка.номка));
		Для каждого стр из строки цикл
			стр.цена=выборка.цена;
			
			//ТекущаяСтрока = стр;
					
			//СтруктураДействий = Новый Структура;
			//СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ОбработкаТабличнойЧастиТоварыКлиент.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект));
			//СтруктураДействий.Вставить("ПересчитатьСумму");
			//СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Ложь));
			//СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомАвтоматическойСкидки", Новый Структура("Очищать", Истина));
			//
			//ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(Объект.Товары, ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
			//
			//ОбработкаТабличнойЧастиТоварыКлиентСервер.ЗаполнитьСуммуВсегоВСтрокеТаблицы(ТекущаяСтрока, Объект.ЦенаВключаетНДС);
			//ОбработкаТабличнойЧастиТоварыКлиентСервер.ОбновитьСуммыПодвала(Объект.Товары, Объект.ЦенаВключаетНДС, СуммаВсего);

		КонецЦикла;
	КонецЦикла;
				 
КонецПроцедуры

&НаКлиенте
Процедура КочетовЗаполнитьЗакупПеред(Команда)
	КочетовЗаполнитьЗакупПередНаСервере();
	Для каждого стр из Объект.товары цикл
		ТекущаяСтрока = стр;
				
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", ОбработкаТабличнойЧастиТоварыКлиент.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект));
		СтруктураДействий.Вставить("ПересчитатьСумму");
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомРучнойСкидки", Новый Структура("Очищать", Ложь));
		СтруктураДействий.Вставить("ПересчитатьСуммуСУчетомАвтоматическойСкидки", Новый Структура("Очищать", Истина));
		
		ОбработкаТабличнойЧастиТоварыКлиент.ПриИзмененииРеквизитовВТЧКлиент(Объект.Товары, ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
		
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ЗаполнитьСуммуВсегоВСтрокеТаблицы(ТекущаяСтрока, Объект.ЦенаВключаетНДС);
		ОбработкаТабличнойЧастиТоварыКлиентСервер.ОбновитьСуммыПодвала(Объект.Товары, Объект.ЦенаВключаетНДС, СуммаВсего);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
&Вместо("ОповещениеПоискаПоШтрихкоду")
Процедура КочетовОповещениеПоискаПоШтрихкоду(Структура, ДополнительныеПараметры)
	Если ЗначениеЗаполнено(Структура) Тогда
		штрихкод=Структура.штрихкод;
		Если Структура.ПоискПоВесовомуТовару=Ложь тогда
			СтруктураПараметровКлиента = ПолученШтрихкодИзСШК(Штрихкод);
			ОбработатьДанныеПоКодуКлиент(СтруктураПараметровКлиента);
			ТекущаяСтрокаЕГАИС = Неопределено;
		Иначе			
			Элементы.Товары.ТекущаяСтрока=ПоискПоВесовомуШтрихКоду(штрихкод);
			ТоварыНоменклатураПриИзменении("");
		КонецЕсли;
		//Zorius
		ПоискПоШтрихкоду("");
		//Zorius
	КонецЕсли;
КонецПроцедуры

Функция ПоискПоВесовомуШтрихКоду(штрихкод)
	номка=ххх_Сервер.ПолучитьВесовойШтрихкод(штрихкод);
	Если значениеЗаполнено(номка) Тогда
		строки=Объект.товары.НайтиСтроки(Новый структура("Номенклатура",номка));
		
		стр=?(ЗначениеЗаполнено(строки),строки[0],неопределено);
		Если стр<>Неопределено Тогда
			стр.количество=стр.количество+1;
		Иначе
			стр=Объект.товары.добавить();
			стр.Номенклатура=номка;
			стр.количество=1;
		КонецЕсли;
		возврат стр.ПолучитьИдентификатор();
	Иначе
		Сообщить("Данные по коду не найдены: "+штрихкод);
		возврат Неопределено;
	КонецЕсли;
КонецФункции


&НаКлиенте
Процедура КочетовКонтрагентНачалоВыбораВместо(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ЭтоИнтерентМагазин() Тогда
		СтандартнаяОбработка=ложь;
		Струк=Новый структура;
		Струк.Вставить("ИнтернетПокупателиПоставщики","ИнтернетПокупателиПоставщики");
		ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора",Струк,ЭтаФорма.Элементы.Контрагент,истина);
	КонецЕсли;
КонецПроцедуры


Функция ЭтоИнтерентМагазин()
	возврат объект.Магазин.ххх_ИнтернетМагазин;
КонецФункции
			 
			 
			 

	 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
