﻿
&Перед("ОбработкаПроведения")
Процедура КочетовОбработкаПроведения(Отказ, РежимПроведения)
	Для каждого стр из Товары Цикл
		Если стр.цена=0 тогда
			Сообщить("В строке: "+стр.НомерСтроки+" не установлена цена. Проведение документа отменено.");
			Отказ=истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&После("ОбработкаПроведения")
Процедура КочетовОбработкаПроведенияПосле(Отказ, РежимПроведения)
	
	//ValMa - при проведении док. "установка цен номенклатуры" регистрируем изменения товара в справочнике "Номенклатура" 
	Если НЕ Отказ Тогда
		сообщить("регистрация изменений для номенклатуры");
		РознВидЦен = Справочники.ххх_Справочник.РозничнаяЦена.Значение;
		
		Выборка = ПланыОбмена.ПланОбменаСОборудованием.Выбрать();
		Пока Выборка.Следующий() Цикл 
			Если Выборка.Ссылка = ПланыОбмена.ПланОбменаСОборудованием.ЭтотУзел() Тогда
				Продолжить;
			КонецЕсли;
			Для каждого СтрТовар из Товары Цикл
				Если СтрТовар.ВидЦены = РознВидЦен Тогда
					//регистрируем товар
					ПланыОбмена.ЗарегистрироватьИзменения(Выборка.Ссылка, СтрТовар.Номенклатура); 
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;	
	КонецЕсли;
	//---
	
	Если ЗначениеЗаполнено(ххх_ИдДокументаМаркетинговойАкции) и не Отказ Тогда
		Для каждого эл из ххх_Акции Цикл
			Если ххх_ИдДокументаМаркетинговойАкции>=эл.номенклатура.ххх_ИдДокаАкции Тогда
				номка=эл.номенклатура.получитьОбъект();
				номка.ххх_ПериодДействияАкцииНачало=эл.ххх_ПериодДействияАкцииНачало;
				номка.ххх_ПериодДействияАкцииКонец=эл.ххх_ПериодДействияАкцииКонец;
				номка.ххх_ИдДокаАкции=ххх_ИдДокументаМаркетинговойАкции;
				номка.Записать();
			КонецЕСли;
		КонецЦикла;
	КонецЕсли;		
	
	Если Не ЗначениеЗаполнено(Константы.ххх_ОрганизацияПринимающаяяПроизводство.Получить()) Тогда
		возврат;
	КонецЕсли;
	
	Запрос=Новый запрос;
	номка=ТОвары.ВыгрузитьКолонку("Номенклатура");
	ИдМас=Новый массив;
	Для каждого эл из номка Цикл
		ИдМас.добавить(эл.ххх_ИдЦентр);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ИдМас",ИдМас);
	Запрос.Текст="ВЫБРАТЬ
	|	dbo_Tovar.id КАК id,
	|	dbo_Tovar.naim КАК naim,
	|	dbo_Tovar.id_post КАК id_post,
	|	dbo_Tovar.id_ed КАК id_ed,
	|	dbo_Tovar.cenZ КАК cenZ,
	|	dbo_Tovar.cenR КАК cenR,
	|	dbo_Tovar.id_grup КАК id_grup,
	|	dbo_Tovar.id_nds КАК id_nds,
	|	dbo_Tovar.naimcas КАК naimcas,
	|	dbo_Tovar.naimsen КАК naimsen,
	|	dbo_Tovar.naimskod КАК naimskod,
	|	dbo_Tovar.id_proizv КАК id_proizv,
	|	dbo_Tovar.dopusk КАК dopusk,
	|	dbo_Tovar.basenaim КАК basenaim,
	|	dbo_Tovar.id_country КАК id_country,
	|	dbo_Tovar.krep КАК krep,
	|	dbo_Tovar.volume КАК volume,
	|	dbo_Tovar.type КАК type
	|ИЗ
	|	ВнешнийИсточникДанных.Пикник23.Таблица.dbo_Tovar КАК dbo_Tovar
	|ГДЕ
	|	dbo_Tovar.id В(&ИдМас)";
	
	Закуп=Справочники.ххх_Справочник.ЗакупочнаяЦена.значение;	
	розница=Справочники.ххх_Справочник.РозничнаяЦена.значение;
	ТчОлд=УбитьЛишнее(Запрос.Выполнить().Выгрузить());
	Для каждого стр из Товары.Выгрузить() Цикл
		стр_dbo_Tovar=ВнешниеИсточникиДанных.Пикник23.Таблицы.dbo_Tovar.СоздатьМенеджерЗаписи();
		стрОлд=ТчОлд.Найти(стр.номенклатура.ххх_ИдЦентр,"id");
		ЗаполнитьЗначенияСвойств(стр_dbo_Tovar,стрОлд);
		стр_dbo_Tovar.dopusk=1;
		Если стр.ВидЦены=Закуп Тогда
			стр_dbo_Tovar.cenZ=стр.цена;
			стрОлд.cenZ=стр.цена;
		ИначеЕсли стр.видЦены=розница тогда
			стр_dbo_Tovar.cenR=стр.Цена;  
			стрОлд.cenR=стр.Цена;
		КонецЕсли;
		стр_dbo_Tovar.Записать(Истина);	
	КонецЦикла;
		
КонецПроцедуры








Функция УбитьЛишнее(Тз)	экспорт
	й=0;
	Для каждого стр из Тз Цикл
		Й=0;
		для каждого ячейка из стр Цикл
			стр[Й]=Стрзаменить(СокрлП(ячейка)," ","");
			стр[Й]=Стрзаменить(СокрлП(ячейка)," ","");
			й=й+1;
		КонецЦикла
	КонецЦикла;
	возврат Тз;
КонецФункции













