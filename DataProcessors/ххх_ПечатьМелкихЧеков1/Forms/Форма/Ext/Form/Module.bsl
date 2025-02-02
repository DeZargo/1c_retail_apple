﻿
&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ОписаниеОповещения=Новый ОписаниеОповещения("ОповещениеПоискаПоШтрихкодуКочетов",ЭтаФорма);
	
	ОткрытьФорму("ОбщаяФорма.КочетовФормаПоискаПоШтрихКоду",,ЭтаФОрма,истина,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры



функция ПолучитьвесыПоНомке(номка)
	
	Запрос=Новый запрос;
	Запрос.УстановитьПараметр("ссылка",номка);
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	ххх_КодыНоменклатурыВесыКассы.Оборудование КАК Оборудование
	             |ИЗ
	             |	РегистрСведений.ххх_КодыНоменклатурыВесыКассы КАК ххх_КодыНоменклатурыВесыКассы
	             |ГДЕ
	             |	ххх_КодыНоменклатурыВесыКассы.Номенклатура.Ссылка = &Ссылка
	             |	И ххх_КодыНоменклатурыВесыКассы.Оборудование.БратьЯчейкиДляЦенниковСЭтихВесов";
	выборка=Запрос.Выполнить().Выбрать();
	выборка.Следующий();
	возврат выборка.Оборудование;
	
КонецФункции

функция Это2х5(номка)
	возврат Номка.ххх_ТипЦенника=Перечисления.ххх_ТипыЦенников.Тип2х5
КонецФункции

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкодуКочетов(Структура, ДополнительныеПараметры) Экспорт	
	Если ЗначениеЗаполнено(Структура) Тогда
		штрихкод=Структура.штрихкод;
		
		Если лев(штрихкод,2)="23" Тогда
			Структура.ПоискПоВесовомуТовару=истина;
		КонецЕсли;

		Если Структура.ПоискПоВесовомуТовару=Ложь тогда
			номка=ПоискПоОбычномуТовару(штрихкод);
		Иначе	
			номка=ПоискПоВесовомуТовару(штрихкод);//ххх_Сервер.ПолучитьВесовойШтрихкод(штрихкод);
		КонецЕсли;
		
		Если не ЗначениеЗаполнено(номка) Тогда
			
			сообщить("Данные по штрихкоду не найдены");
			
		ИначеЕсли Это2х5(номка) Тогда
			
			номенклатура=номка;
			весы=ПолучитьвесыПоНомке(номка);
			ТабДок=ПечатьНаСервере2х5();
			//ТабДок.показать();
			ТабДок.напечатать()
			
		Иначе
			
			ТабДок=Печать(номка,Структура.ПоискПоВесовомуТовару);
			//ТабДок.показать();
			ТабДок.напечатать()
		КонецЕсли;

		//ТабДок=Печать(штрихкод,Структура.ПоискПоВесовомуТовару);
		//Если не ЗначениеЗаполнено(Табдок) Тогда
		//	сообщить("Данные по штрихкоду не найдены");
		//Иначе
		//	ТабДок.показать();
		//КонецЕсли;
		//ТабДок.Напечатать();
		ПоискПоШтрихкоду("");
		//Zorius
	КонецЕсли;
КонецПроцедуры

Функция ПоискПоВесовомуТовару(штрихкод)
	возврат ххх_Сервер.ПолучитьВесовойШтрихкод(штрихкод);
КонецФункции

Функция ПоискПоОбычномуТовару(штрихкод)
	
	Запрос=Новый запрос;
	Запрос.УстановитьПараметр("штрихкод",штрихкод);
	Запрос.Текст="ВЫБРАТЬ
	             |	Штрихкоды.Владелец КАК Владелец
	             |ИЗ
	             |	РегистрСведений.Штрихкоды КАК Штрихкоды
	             |ГДЕ
	             |	Штрихкоды.Штрихкод = &Штрихкод";
	
	выборка=Запрос.Выполнить().Выбрать();
	
	Если выборка.Следующий() Тогда
		возврат выборка.владелец;
	КонецЕсли;
	возврат неопределено;
	
	
КонецФункции



функция печать(номка,ПоискПоВесовомуТовару)
	
	
	//Если ПоискПоВесовомуТовару=Ложь тогда
	//	номка=ПоискПоОбычномуТовару(штрихкод);
	//Иначе	
	//	номка=ххх_Сервер.ПолучитьВесовойШтрихкод(штрихкод);
	//КонецЕсли;
	//
	//Если не ЗначениеЗаполнено(номка) Тогда
	//	
	//	возврат неопределено;
	//	
	//КонецЕсли;	
		
	Запрос=Новый запрос;
	Запрос.УстановитьПараметр("номка",номка);
	Запрос.УстановитьПараметр("красныйЦенник",Справочники.ххх_Справочник.КрасныйЦенник.Значение);
	Запрос.УстановитьПараметр("ВидЦены",справочники.ххх_Справочник.РозничнаяЦена.Значение);
	Запрос.УстановитьПараметр("ОрганизацияТорговлиАлкоголем",Справочники.ххх_Справочник.ОрганизацияТорговлиАлкоголем.Значение);
	Запрос.УстановитьПараметр("ОрганизацияТорговлиПивом",Справочники.ххх_Справочник.ОрганизацияТорговлиПивом.Значение);
	Запрос.УстановитьПараметр("ПапкаНоменклатурыАлкоголь",ПапкаНоменклатурыАлкоголь);
	Запрос.УстановитьПараметр("EAN13",ПланыВидовХарактеристик.ТипыШтрихкодов.EAN13);
	
	Запрос.Текст="ВЫБРАТЬ
	             |	ВЫБОР
	             |		КОГДА НоменклатураСегмента.Сегмент = &красныйЦенник
	             |			ТОГДА ИСТИНА
	             |		ИНАЧЕ ЛОЖЬ
	             |	КОНЕЦ КАК красный,
	             |	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	             |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	             |	Штрихкоды.Штрихкод КАК Штрихкод,
	             |	ВЫБОР
	             |		КОГДА ЦеныНоменклатурыСрезПоследних.Номенклатура В ИЕРАРХИИ (&ПапкаНоменклатурыАлкоголь)
	             |			ТОГДА &ОрганизацияТорговлиАлкоголем
	             |		ИНАЧЕ &ОрганизацияТорговлиПивом
	             |	КОНЕЦ КАК Организация
	             |ПОМЕСТИТЬ йцу
	             |ИЗ
	             |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	             |			,
	             |			ВидЦены = &ВидЦены
	             |				И Номенклатура = &номка) КАК ЦеныНоменклатурыСрезПоследних
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
	             |		ПО (НоменклатураСегмента.Номенклатура = ЦеныНоменклатурыСрезПоследних.Номенклатура)
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	             |		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = Штрихкоды.Владелец
	             |ГДЕ
	             |	Штрихкоды.ТипШтрихкода = &EAN13
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	йцу.красный КАК красный,
	             |	йцу.Номенклатура КАК Номенклатура,
	             |	йцу.Цена КАК Цена,
	             |	МАКСИМУМ(йцу.Штрихкод) КАК Штрихкод,
	             |	йцу.Организация КАК Организация
	             |ИЗ
	             |	йцу КАК йцу
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	йцу.красный,
	             |	йцу.Номенклатура,
	             |	йцу.Организация,
	             |	йцу.Цена";
	
	//ценник=Справочники.ХранилищеШаблонов.НайтиПоНаименованию("3х7 (61мм*39мм)");
	
	//шаблон=ценник.Шаблон.Получить();
	
	выборка=Запрос.Выполнить().Выбрать();
	
	если выборка.Следующий() Тогда
	
		ТабДок=Новый ТабличныйДокумент;
		
		//ТабДок.Автомасштаб=истина;
		//ТабДок.ВерхнийКолонтитул=0;
		//ТабДок.НижнийКолонтитул=0;
		ТабДок.ПолеСверху=0;
		ТабДок.ПолеСлева=0;
		ТабДок.ПолеСнизу=0;
		ТабДок.ПолеСправа=0;

		
		//ТабДок.ИмяПринтера=Принтеры1;
		
		Обработка =  РеквизитФормыВЗначение("Объект");
		
		если выборка.красный тогда
			Макет = Обработка.ПолучитьМакет("МакетКрасный");
			ОблЦена=Макет.ПолучитьОбласть("Область");
			ТабДок.ИмяПринтера=ПринтерыКрасный;
			УголПоворота=0;
		иначе
			Макет = Обработка.ПолучитьМакет("МакетБелый");
			ОблЦена=Макет.ПолучитьОбласть("Область");
			ОблЦена.Параметры.ЦенаСоСкидкой=выборка.цена-выборка.цена*0.05;
			ТабДок.ИмяПринтера=Принтеры1;
			УголПоворота=0;
		конецесли;
		//Макет = Обработка.ПолучитьМакет("МакетБелый"); 
			
		
		//ОблЦена=Макет.ПолучитьОбласть("Область");
		ОблЦена.Параметры.Цена=выборка.цена;
		попытка
			ОблЦена.Параметры.ЦенаСоСкидкой=выборка.цена-выборка.цена*0.05;
		Исключение
		КонецПопытки;
		ОблЦена.Параметры.ТекущееВремя=ТекущаяДата();
		ОблЦена.Параметры.Организация=выборка.Организация;                                           
		ОблЦена.Параметры.МойШтрихКод=выборка.Штрихкод;
		ОблЦена.Параметры.ЕдиницаИзмерения=выборка.Номенклатура.ЕдиницаИзмерения;
		ОблЦена.Параметры.Страна=выборка.Номенклатура.СтранаПроисхождения;
		ОблЦена.Параметры.НаименованиеЦенник=выборка.Номенклатура.ххх_НаименованиеЦенник;
		
		
		Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	    КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;

		ПараметрыШтрихкода = Новый Структура;
		ПараметрыШтрихкода.Вставить("Ширина",	30);//Окр(ОблЦена.Рисунки.Штрихкод.Ширина /КоличествоМиллиметровВПикселе));
		ПараметрыШтрихкода.Вставить("Высота",	Окр(ОблЦена.Рисунки.Штрихкод.Высота /КоличествоМиллиметровВПикселе));
		ПараметрыШтрихкода.Вставить("Штрихкод",				выборка.Штрихкод);
		ПараметрыШтрихкода.Вставить("ТипКода",				1);
		ПараметрыШтрихкода.Вставить("ОтображатьТекст",		ложь);
		ПараметрыШтрихкода.Вставить("РазмерШрифта",			10);
		ПараметрыШтрихкода.Вставить("УголПоворота",		УголПоворота);

		ОблЦена.Рисунки.Штрихкод.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
					
		ТабДок.Вывести(ОблЦена);
		
		//ТабДок.параметры.ПараметрМакета5=123;
		
		возврат ТабДок; 
	
	КонецЕсли;	
		
КонецФункции


&НаКлиенте
Процедура Печать1(Команда)
	Если ВидЦенника="А4" Тогда
		ТабДок=ПечатьНаСервере();
	Иначе
		ТабДок=ПечатьНаСервере2х5();
	КонецЕсли;
	ТабДок.показать();
	//ТабДок.Напечатать();
КонецПроцедуры


Функция ПолучитьОрганизациюПоВидуНоменклатуры(ВидНоменклатуры)
	Если видНоменклатуры=Справочники.ххх_Справочник.ВидНоменклатурыАлкоголь.значение Тогда
		возврат Справочники.ххх_Справочник.ОрганизацияТорговлиАлкоголем.Значение
	Иначе	
		возврат Справочники.ххх_Справочник.ОрганизацияТорговлиПивом.Значение
	КонецЕсли;
КонецФункции


&НаСервере
функция ПечатьНаСервере2х5()
	Запрос=Новый запрос;
	Запрос.УстановитьПараметр("номка",номенклатура);
	Запрос.УстановитьПараметр("Сегмент",Справочники.ххх_Справочник.КрасныйЦенник.Значение);
	Запрос.УстановитьПараметр("ВидЦены",справочники.ххх_Справочник.РозничнаяЦена.Значение);
	Запрос.УстановитьПараметр("ОрганизацияТорговлиАлкоголем",Справочники.ххх_Справочник.ОрганизацияТорговлиАлкоголем.Значение);
	Запрос.УстановитьПараметр("ОрганизацияТорговлиПивом",Справочники.ххх_Справочник.ОрганизацияТорговлиПивом.Значение);
	Запрос.УстановитьПараметр("ПапкаНоменклатурыАлкоголь",ПапкаНоменклатурыАлкоголь);
	Запрос.УстановитьПараметр("Оборудование",весы);
	Запрос.УстановитьПараметр("EAN13",ПланыВидовХарактеристик.ТипыШтрихкодов.EAN13);

	Запрос.Текст="ВЫБРАТЬ
	             |	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	             |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	             |	ЕСТЬNULL(ххх_КодыНоменклатурыВесыКассы.Код, 0) КАК Код,
	             |	ВЫБОР
	             |		КОГДА НоменклатураСегмента.Сегмент = &Сегмент
	             |			ТОГДА ""красный""
	             |		ИНАЧЕ ""белый""
	             |	КОНЕЦ КАК ТипЦенника,
	             |	Штрихкоды.Штрихкод КАК Штрихкод,
	             |	ВЫБОР
	             |		КОГДА ЦеныНоменклатурыСрезПоследних.Номенклатура В ИЕРАРХИИ (&ПапкаНоменклатурыАлкоголь)
	             |			ТОГДА &ОрганизацияТорговлиАлкоголем
	             |		ИНАЧЕ &ОрганизацияТорговлиПивом
	             |	КОНЕЦ КАК Организация
	             |ПОМЕСТИТЬ йцу
	             |ИЗ
	             |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	             |			,
	             |			ВидЦены = &ВидЦены
	             |				И Номенклатура = &номка) КАК ЦеныНоменклатурыСрезПоследних
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ххх_КодыНоменклатурыВесыКассы КАК ххх_КодыНоменклатурыВесыКассы
	             |		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = ххх_КодыНоменклатурыВесыКассы.Номенклатура
	             |			И (ххх_КодыНоменклатурыВесыКассы.Оборудование = &Оборудование)
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НоменклатураСегмента КАК НоменклатураСегмента
	             |		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = НоменклатураСегмента.Номенклатура
	             |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	             |		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = Штрихкоды.Владелец
	             |ГДЕ
	             |	Штрихкоды.ТипШтрихкода = &EAN13
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	йцу.Номенклатура КАК Номенклатура,
	             |	йцу.Цена КАК Цена,
	             |	йцу.Код КАК Код,
	             |	йцу.ТипЦенника КАК ТипЦенника,
	             |	МАКСИМУМ(йцу.Штрихкод) КАК Штрихкод,
	             |	йцу.Организация КАК Организация
	             |ИЗ
	             |	йцу КАК йцу
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	йцу.Номенклатура,
	             |	йцу.Организация,
	             |	йцу.ТипЦенника,
	             |	йцу.Цена,
	             |	йцу.Код";
	
	//ценник=Справочники.ХранилищеШаблонов.НайтиПоНаименованию("3х7 (61мм*39мм)");
	
	//шаблон=ценник.Шаблон.Получить();
	
	выборка=Запрос.Выполнить().Выбрать();
	
	если выборка.Следующий() Тогда
	
		ТабДок=Новый ТабличныйДокумент;
		
		//ТабДок.Автомасштаб=истина;
		
		ТабДок.ПолеСверху=0;
		ТабДок.ПолеСлева=0;
		ТабДок.ПолеСнизу=0;
		ТабДок.ПолеСправа=0;

		
		ТабДок.ИмяПринтера=Принтеры1;
		
		Обработка =  РеквизитФормыВЗначение("Объект");
		
		если выборка.ТипЦенника="красный" тогда
			Макет = Обработка.ПолучитьМакет("Макет2х5Красный");
			//ОблЦена=Макет.ПолучитьОбласть("Область");
			ТабДок.ИмяПринтера=ПринтерыКрасный;
			УголПоворота=270;
		иначе
			Макет = Обработка.ПолучитьМакет("Макет2х5");
			//ОблЦена=Макет.ПолучитьОбласть("Область");
			ТабДок.ИмяПринтера=Принтеры1;
			УголПоворота=270;
		//	ОблЦена.Параметры.ЦенаСоСкидкой=выборка.цена-выборка.цена*0.05;
		конецесли;
		//Макет = Обработка.ПолучитьМакет("МакетБелый"); 
		
		ОблШапка=Макет.ПолучитьОбласть("Шапка");
		ОблШапка.Параметры.Организация=выборка.Организация;
		ОблШапка.Параметры.НаименованиеЦенник=выборка.Номенклатура.ххх_НаименованиеЦенник;

		ТабДок.Вывести(ОблШапка);
		
		
		Если ЗначениеЗаполнено(Выборка.код) Тогда
			ОблКнопка=Макет.ПолучитьОбласть("СКнопкой");
			ОблКнопка.Параметры.Ячейка=Выборка.код;
		Иначе
			ОблКнопка=Макет.ПолучитьОбласть("БезКнопки"); 
		КонецЕсли;
		
		ТабДок.Вывести(ОблКнопка);

		ОблПодвал=Макет.ПолучитьОбласть("Подвал");

		
		если не выборка.ТипЦенника="красный" тогда
			ОблПодвал.Параметры.ЦенаСоСкидкой=выборка.цена-выборка.цена*0.05;
		КонецЕсли;
		ОблПодвал.Параметры.ТекущееВремя=ТекущаяДата();

		ОблПодвал.Параметры.Цена=выборка.цена;
		ОблПодвал.Параметры.МойШтрихКод=выборка.Штрихкод;
		ОблПодвал.Параметры.ЕдиницаИзмерения=выборка.Номенклатура.ЕдиницаИзмерения;
		ОблПодвал.Параметры.Страна=выборка.Номенклатура.СтранаПроисхождения;
				
		Эталон = Обработки.ПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	    КоличествоМиллиметровВПикселе = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;

		ПараметрыШтрихкода = Новый Структура;
		ПараметрыШтрихкода.Вставить("Ширина",	50);//Окр(ОблЦена.Рисунки.Штрихкод.Ширина /КоличествоМиллиметровВПикселе));
		ПараметрыШтрихкода.Вставить("Высота",	109.0000000000000000000000000000001);
		ПараметрыШтрихкода.Вставить("Штрихкод",				выборка.Штрихкод);
		ПараметрыШтрихкода.Вставить("ТипКода",				1);
		ПараметрыШтрихкода.Вставить("ОтображатьТекст",		ложь);
		ПараметрыШтрихкода.Вставить("РазмерШрифта",			10);
		ПараметрыШтрихкода.Вставить("УголПоворота",		УголПоворота);

		ОблПодвал.Рисунки.Штрихкод.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);

		
					
		ТабДок.Вывести(ОблПодвал);
		
		//ТабДок.параметры.ПараметрМакета5=123;
		
		возврат ТабДок; 
	
	КонецЕсли;	

КонецФункции



&НаСервере
функция ПечатьНаСервере()
	Запрос=Новый запрос;
	Запрос.УстановитьПараметр("номка",номенклатура);
	Запрос.УстановитьПараметр("красныйЦенник",Справочники.ххх_Справочник.КрасныйЦенник.Значение);
	Запрос.УстановитьПараметр("ВидЦены",справочники.ххх_Справочник.РозничнаяЦена.Значение);
	Запрос.УстановитьПараметр("Оборудование",весы);
	Запрос.Текст="ВЫБРАТЬ
	             |	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	             |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	             |	ххх_КодыНоменклатурыВесыКассы.Код КАК Код,
	             |	МАКСИМУМ(Штрихкоды.Штрихкод) КАК Штрихкод
	             |ИЗ
	             |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	             |			,
	             |			ВидЦены = &ВидЦены
	             |				И Номенклатура = &номка) КАК ЦеныНоменклатурыСрезПоследних
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ххх_КодыНоменклатурыВесыКассы КАК ххх_КодыНоменклатурыВесыКассы
	             |		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = ххх_КодыНоменклатурыВесыКассы.Номенклатура
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.Штрихкоды КАК Штрихкоды
	             |		ПО ЦеныНоменклатурыСрезПоследних.Номенклатура = Штрихкоды.Владелец
	             |ГДЕ
	             |	ххх_КодыНоменклатурыВесыКассы.Оборудование = &Оборудование
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ЦеныНоменклатурыСрезПоследних.Номенклатура,
	             |	ЦеныНоменклатурыСрезПоследних.Цена,
	             |	ххх_КодыНоменклатурыВесыКассы.Код";
	
	//ценник=Справочники.ХранилищеШаблонов.НайтиПоНаименованию("3х7 (61мм*39мм)");
	
	//шаблон=ценник.Шаблон.Получить();
	
	выборка=Запрос.Выполнить().Выбрать();
	
	если выборка.Следующий() Тогда
	
		ТабДок=Новый ТабличныйДокумент;
		
		ТабДок.Автомасштаб=истина;
		
		ТабДок.ИмяПринтера=Принтеры1;
		
		Обработка =  РеквизитФормыВЗначение("Объект");
		
		//если выборка.красный тогда
			Макет = Обработка.ПолучитьМакет("МакетА4");
			ОблЦена=Макет.ПолучитьОбласть("Область");
		//иначе
		//	Макет = Обработка.ПолучитьМакет("МакетБелый");
		//	ОблЦена=Макет.ПолучитьОбласть("Область");
		//	ОблЦена.Параметры.ЦенаСоСкидкой=выборка.цена-выборка.цена*0.05;
		//конецесли;
		//Макет = Обработка.ПолучитьМакет("МакетБелый"); 
			
		
		//ОблЦена=Макет.ПолучитьОбласть("Область");
		ОблЦена.Параметры.Цена=выборка.цена;
		//ОблЦена.Параметры.ЦенаСоСкидкой=выборка.цена-выборка.цена*0.05;
		ОблЦена.Параметры.ТекущееВремя=ТекущаяДата();
		ОблЦена.Параметры.Организация=ПолучитьОрганизациюПоВидуНоменклатуры(выборка.номенклатура.ВидНоменклатуры);       
		ОблЦена.Параметры.Ячейка=Выборка.код;
		ОблЦена.Параметры.МойШтрихКод=выборка.Штрихкод;
//		ОблЦена.Параметры.ЕдиницаИзмерения=выборка.Номенклатура.ЕдиницаИзмерения;
		ОблЦена.Параметры.Страна=выборка.Номенклатура.СтранаПроисхождения;
		ОблЦена.Параметры.НаименованиеЦенник=выборка.Номенклатура.ххх_НаименованиеЦенник;
		
					
		ТабДок.Вывести(ОблЦена);
		
		//ТабДок.параметры.ПараметрМакета5=123;
		
		возврат ТабДок; 
	
	КонецЕсли;	

КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыборПринтеров=новый массив;
	ВыборПринтеров.Очистить(); // список значений 
	Принтеры = Новый COMОбъект ("WScript.Network"); 
	prn = Принтеры.EnumPrinterConnections(); 
	i = 0; 
	Пока i < prn.Count()-1 Цикл 
	    ВыборПринтеров.Добавить(prn.Item(i+1)); 
	    i = i + 2; 
	КонецЦикла; 
	ЭтаФорма.Элементы.Принтеры1.СписокВыбора.ЗагрузитьЗначения(ВыборПринтеров); // загоняем в комбобокс
	ЭтаФорма.Элементы.ПринтерыКрасный.СписокВыбора.ЗагрузитьЗначения(ВыборПринтеров); // загоняем в комбобокс

КонецПроцедуры

&НаКлиенте
Процедура НоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	
	Если не ЗначениеЗаполнено(Весы) Тогда
		сообщить("Выьберите весы!");
		возврат
	КонецЕсли;
	
	
	
	
	//Оповещение-Новый ОповещениеСистемыВзаимодействия
	
	ЗначениеОтбора  = Новый Структура("Оборудование", Весы);
	//ПараметрыВыбора = Новый Структура("Отбор", ЗначениеОтбора);
	//
	ОткрытьФорму("Обработка.ххх_ПечатьМелкихЧеков.Форма.ФормаВыбораНоменклатуры",ЗначениеОтбора,элемент,истина,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Номенклатура=ВыбранноеЗначение;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	Запрос=Новый запрос;
	Запрос.Текст="ВЫБРАТЬ
	             |	Номенклатура.Ссылка КАК Ссылка
	             |ИЗ
	             |	Справочник.Номенклатура КАК Номенклатура
	             |ГДЕ
	             |	Номенклатура.ЭтоГруппа
	             |	И Номенклатура.ххх_ИдЦентр = ""17""";
	
	выборка=Запрос.Выполнить().Выбрать();
	выборка.Следующий();
	ПапкаНоменклатурыАлкоголь=выборка.Ссылка;
	
	
КонецПроцедуры












































