﻿
&НаСервере
&После("ДобавитьТовары")
Процедура КочетовДобавитьТовары(Таблица, ИдентификаторСтроки)
	Для каждого стр из Объект.Товары Цикл
		стр.Страна=Стр.Номенклатура.СтранаПроисхождения;
	КонецЦикла;
КонецПроцедуры

&НаСервере
&Вместо("ЗаполнитьТаблицуТоваровНаСервере")
Процедура КочетовЗаполнитьТаблицуТоваровНаСервере(Сохранять)
	
	// Сохранение выбранных позиций для их последующего восстановления.
	Если Сохранять Тогда
		ТаблицаВыбранныеПозиции = Объект.Товары.Выгрузить();
	КонецЕсли;
	
	
	// Поля необходимые для вывода в таблицу товаров на форме.
	СтруктураНастроек = Обработки.ПечатьЭтикетокИЦенников.ПолучитьПустуюСтруктуруНастроек();
	
	СтруктураНастроек.ОбязательныеПоля.Добавить("Цена");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Штрихкод");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Количество");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура");
	СтруктураНастроек.ОбязательныеПоля.Добавить("НаименованиеПолное");
	Если Объект.ИспользоватьСправкиБ Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("Справка2");
		СтруктураНастроек.ОбязательныеПоля.Добавить("ШтрихСправкиБ");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("Характеристика");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры") Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("Упаковка");
	КонецЕсли;
	Если ИспользоватьОбменСПодключаемымОборудованием Тогда
		СтруктураНастроек.ОбязательныеПоля.Добавить("SKU");
	КонецЕсли;
	СтруктураНастроек.ОбязательныеПоля.Добавить("ОстатокНаСкладе");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Организация");
	
	// Шаблоны этикеток и ценников.
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура.ВидНоменклатуры.ШаблонЭтикетки");
	СтруктураНастроек.ОбязательныеПоля.Добавить("Номенклатура.ВидНоменклатуры.ШаблонЦенника");
	
	СтруктураНастроек.ПараметрыДанных.Вставить("Магазин", Объект.Магазин);
	СтруктураНастроек.ПараметрыДанных.Вставить("ВидЦены"    , Объект.ВидЦены);
	СтруктураНастроек.ПараметрыДанных.Вставить("МагазинДляЦен"    , Объект.Магазин);
	СтруктураНастроек.ПараметрыДанных.Вставить("ПравилоЦенообразования" , Объект.ПравилоЦенообразования);
	СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныПоВидуЦены" , Объект.ЦеныПоВидуЦены);	
	СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныНаДату" , Объект.ЦеныНаДату);
	СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныНазначенныеДействующие" , Объект.ЦеныНазначенныеДействующие);
	СтруктураНастроек.ПараметрыДанных.Вставить("ВидМинимальныхЦенПродажи", Объект.ВидМинимальныхЦенПродажи);
	СтруктураНастроек.ПараметрыДанных.Вставить("ЦеныМинимальные", Объект.УчитыватьЦеныМинимальные);
	СтруктураНастроек.ПараметрыДанных.Вставить("СписокДокументов", СписокДокументов);
	
	ИспользоватьАссортимент = ПолучитьФункциональнуюОпцию("УстанавливатьВидыЦенВАссортименте")
								И АссортиментСервер.ПолучитьФункциональнуюОпциюКонтроляАссортимента(Объект.Магазин);
	СтруктураНастроек.ПараметрыДанных.Вставить("ИспользоватьАссортимент", ИспользоватьАссортимент);
	Если ИспользоватьАссортимент Тогда
		ФорматМагазина = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Магазин, "ФорматМагазина");
		СтруктураНастроек.ПараметрыДанных.Вставить("ФорматМагазина", ФорматМагазина);
	КонецЕсли;
	СтруктураНастроек.ПараметрыДанных.Вставить("ИспользоватьСправкиБ", Объект.ИспользоватьСправкиБ);
	
	СтруктураНастроек.КомпоновщикНастроек = КомпоновщикНастроек;
	Если Объект.ИсходныеДанные.Количество() > 0 ИЛИ Объект.ПечатьИзДокумента Тогда
		СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "ПоляШаблона";
		СтруктураНастроек.ИсходныеДанные = Объект.ИсходныеДанные.Выгрузить();
	Иначе
		СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "ПоляШаблонаБД";
	КонецЕсли;
	
	Объект.Товары.Очистить();
	
	// Загрузка сформированного списка товаров.
	СтруктураРезультата = Обработки.ПечатьЭтикетокИЦенников.ПодготовитьСтруктуруДанных(СтруктураНастроек);
	
	ИспользоватьХарактеристикиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры");
	ИспользоватьУпаковкиНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьУпаковкиНоменклатуры");
	
	ДобавитьСкладИОрганизациюПродажи(
		СтруктураРезультата.ТаблицаТоваров,
		Объект.Магазин,
		МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	
	Для Каждого СтрокаТЧ Из СтруктураРезультата.ТаблицаТоваров Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.Номенклатура         = СтрокаТЧ.Номенклатура;
		
		Если Объект.ИспользоватьСправкиБ Тогда
			НоваяСтрока.Справка2         = СтрокаТЧ.Справка2;
		КонецЕсли;
		
		Если ИспользоватьХарактеристикиНоменклатуры Тогда
			НоваяСтрока.Характеристика       = СтрокаТЧ.Характеристика;
		КонецЕсли;
		
		НоваяСтрока.НаименованиеПолное = СтрокаТЧ.НаименованиеПолное;
		
		Если ИспользоватьУпаковкиНоменклатуры Тогда
			НоваяСтрока.Упаковка             = СтрокаТЧ.Упаковка;
		КонецЕсли;
		
		НоваяСтрока.Цена                 = СтрокаТЧ.Цена;
		НоваяСтрока.Штрихкод             = СтрокаТЧ.Штрихкод;
		Если Объект.ИспользоватьСправкиБ Тогда
			НоваяСтрока.ШтрихСправкиБ             = СтрокаТЧ.ШтрихСправкиБ;
		КонецЕсли;
		НоваяСтрока.ШаблонЦенника        = СтрокаТЧ[СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицыТоваров.Получить("Номенклатура.ВидНоменклатуры.ШаблонЦенника")];
		
		Если ЗначениеЗаполнено(НоваяСтрока.ШаблонЦенника) Тогда
			Если НоваяСтрока.ШаблонЦенника.ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток Тогда
				НоваяСтрока.ТипШаблонаЦенника = 1;
			Иначе
				НоваяСтрока.ТипШаблонаЦенника = 2;
			КонецЕсли;
		Иначе
			НоваяСтрока.ТипШаблонаЦенника = 0;
		КонецЕсли;
		
		НоваяСтрока.ШаблонЭтикетки       = СтрокаТЧ[СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицыТоваров.Получить("Номенклатура.ВидНоменклатуры.ШаблонЭтикетки")];
		
		Если ЗначениеЗаполнено(НоваяСтрока.ШаблонЭтикетки) Тогда
			Если НоваяСтрока.ШаблонЭтикетки.ТипШаблона = Перечисления.ТипыШаблонов.ЭтикеткаЦенникПринтераЭтикеток Тогда
				НоваяСтрока.ТипШаблонаЭтикетки = 1;
			Иначе
				НоваяСтрока.ТипШаблонаЭтикетки = 2;
			КонецЕсли;
		Иначе
			НоваяСтрока.ТипШаблонаЭтикетки = 0;
		КонецЕсли;
		
		НоваяСтрока.ОстатокНаСкладе      = СтрокаТЧ.ОстатокНаСкладе;
		НоваяСтрока.КоличествоВДокументе = СтрокаТЧ.Количество;
		
		Если ИспользоватьОбменСПодключаемымОборудованием Тогда
			НоваяСтрока.SKU              = СтрокаТЧ.SKU;
		КонецЕсли;
		
		НоваяСтрока.Склад = СтрокаТЧ.СкладПродажи;
		НоваяСтрока.Организация = СтрокаТЧ.ОрганизацияПродажи;
		
		УстановитьКоличествоПоУмолчаниюВСтрокеТЧНаСервере(НоваяСтрока);
		
		// Восстановление позиций, сохраненных перед заполнением ТЧ. 
		Если Сохранять Тогда
			ПараметрыОтбора = Новый Структура();
			ПараметрыОтбора.Вставить("Номенклатура", НоваяСтрока.Номенклатура);
			Если Объект.ИспользоватьСправкиБ Тогда
				ПараметрыОтбора.Вставить("Справка2", НоваяСтрока.Номенклатура);
			КонецЕсли;
			Если ИспользоватьХарактеристикиНоменклатуры Тогда
				ПараметрыОтбора.Вставить("Характеристика", НоваяСтрока.Характеристика);
			КонецЕсли;
			Если ИспользоватьУпаковкиНоменклатуры Тогда
				ПараметрыОтбора.Вставить("Упаковка", НоваяСтрока.Упаковка);
			КонецЕсли;
			НайденныеСтроки = ТаблицаВыбранныеПозиции.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество() > 0 Тогда
				ЗаполнитьЗначенияСвойств(НоваяСтрока, НайденныеСтроки[0],"ШаблонЦенника, ШаблонЭтикетки, КоличествоЦенников, КоличествоЭтикеток");
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока.Выбран = ПроверитьВозможностьВыбораТовара(НоваяСтрока, Объект.Режим);
		
	КонецЦикла;
	
	Элементы.Товары.Обновить();
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);

	Для каждого стр из Объект.Товары Цикл
		
		стр.Страна=Стр.Номенклатура.СтранаПроисхождения;
		
		Наб=РегистрыСведений.Штрихкоды.СоздатьНаборЗаписей();
		Наб.Отбор.Владелец.установить(Стр.номенклатура);
		наб.Прочитать();
		тч=наб.Выгрузить();
		тч.Сортировать("Дата Убыв");
		Если тч.Количество()>1 Тогда
			Стр.ШтрихКод=тч[0].штрихкод;
		КонецЕсли;

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
			ПоискПоВесовомуШтрихКоду(штрихкод);
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
		Иначе
			стр=Объект.товары.добавить();
			стр.Номенклатура=номка;
			зАПРОС=нОВЫЙ запрос;
			Запрос.УстановитьПараметр("номка",номка);
			Запрос.УстановитьПараметр("розничная",Справочники.ххх_Справочник.РозничнаяЦена.Значение);
			Запрос.Текст="ВЫБРАТЬ
			             |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
			             |ИЗ
			             |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
			             |			,
			             |			ВидЦены = &розничная
			             |				И Номенклатура = &номка) КАК ЦеныНоменклатурыСрезПоследних";
			Выборка=Запрос.Выполнить().Выбрать();
			Если выборка.Следующий() Тогда
				стр.цена=выборка.цена;
			КонецЕсли;
			стр.КоличествоЦенников=1;
			стр.штрихкод=штрихкод;
			стр.Страна=номка.СтранаПроисхождения;
			наб=РегистрыСведений.НастройкиПользователей.СоздатьНаборЗаписей();
			наб.Отбор.Пользователь.установить(ПараметрыСеанса.АвторизованныйПользователь);
			наб.Отбор.Настройка.установить(ПланыВидовХарактеристик.НастройкиПользователей.ОсновнаяОрганизация);
			наб.Прочитать();
			Если наб.Количество()>0 Тогда
				стр.Организация=Наб[0].значение;
			КонецЕсли;
		КонецЕсли;
		возврат стр.ПолучитьИдентификатор();
	Иначе
		Сообщить("Данные по коду не найдены: "+штрихкод);
		возврат Неопределено;
	КонецЕсли;
КонецФункции


&НаКлиенте
Процедура ИнверсироватьВыбранные(Команда)
	Для каждого стр из Объект.Товары цикл
		стр.выбран=не стр.выбран;
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура ПрогрузитьВесы(Команда)
	ПрогрузитьВесыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПрогрузитьВесыНаСервере()
	видыЦен=Новый массив;
	видыЦен.Добавить(Справочники.ххх_Справочник.РозничнаяЦена.Значение);
	Оборудования=Новый Массив;
	ЗАпрос=новый Запрос;
	Запрос.УстановитьПараметр("Номенклатура",Объект.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	Запрос.Текст="ВЫБРАТЬ
	             |	ххх_КодыНоменклатурыВесыКассы.Оборудование КАК Оборудование
	             |ИЗ
	             |	РегистрСведений.ххх_КодыНоменклатурыВесыКассы КАК ххх_КодыНоменклатурыВесыКассы
	             |ГДЕ
	             |	ххх_КодыНоменклатурыВесыКассы.Номенклатура В(&Номенклатура)
	             |	И ххх_КодыНоменклатурыВесыКассы.Оборудование.ПометкаУдаления = ЛОЖЬ
	             |	И ххх_КодыНоменклатурыВесыКассы.Оборудование.УстройствоИспользуется
	             |
	             |СГРУППИРОВАТЬ ПО
	             |	ххх_КодыНоменклатурыВесыКассы.Оборудование";
	Оборудования=Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Оборудование");
	Тз=Объект.Товары.Выгрузить(,"Номенклатура,Страна");
	Тз.колонки.страна.имя="Производитель";
	ххх_Сервер.ОтправитьЦеныНаВесы(Тз, видыЦен,,оборудования);
КонецПроцедуры


&НаКлиенте
Процедура УстановитьОрганизацию(Команда)
	Для каждого стр из Объект.Товары Цикл
		стр.Организация=Организация;
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьСписокШтрихКодов(Строка)	
	Если Строка.Номенклатура<>Неопределено Тогда
		штрихкоды=ПолучитьШтрихКоды(Строка.Номенклатура);
		Элементы.ТоварыШтрихкод.СписокВыбора.Очистить();
		Строка.ШтрихКод="";
		Для каждого штрих из штрихкоды Цикл
			Элементы.ТоварыШтрихкод.СписокВыбора.Добавить(штрих);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьШтрихКоды(номка)
	Наб=РегистрыСведений.Штрихкоды.СоздатьНаборЗаписей();
	Наб.Отбор.Владелец.установить(номка);
	Наб.Прочитать();
	Возврат наб.ВыгрузитьКолонку("ШтрихКод");
КонецФункции

&НаКлиенте
Процедура ТоварыШтрихкодНачалоВыбора1()
	ЗаполнитьСписокШтрихКодов(Элементы.Товары.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура КочетовТоварыШтрихкодНачалоВыбораПосле(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТоварыШтрихкодНачалоВыбора1();
КонецПроцедуры


&НаСервере
Процедура КочетовПриСозданииНаСервереВместо(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеКолонкиНоменклатуры = ЗначениеНастроекПовтИсп.ПолучитьЗначениеКонстанты("ДополнительнаяКолонкаПриОтображенииНоменклатуры");
	
	ИспользоватьПрименениеЦен = ПолучитьФункциональнуюОпцию("ИспользоватьПрименениеЦен");
	
	ИспользоватьОбменСПодключаемымОборудованием = ПолучитьФункциональнуюОпцию("ИспользоватьОбменСПодключаемымОборудованием");
	
	ПодключаемоеОборудованиеРТВызовСервера.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	
	ЗагрузитьНастройкиОтбораПоУмолчанию(
		КомпоновщикНастроек,
		"ПоляШаблона");
	ЗагрузитьНастройкиОтбораПоУмолчанию(
		КомпоновщикНастроекДисконтныхКарт,
		"ПоляШаблонаДисконтнаяКарта");
	ЗагрузитьНастройкиОтбораПоУмолчанию(
		КомпоновщикНастроекРегистрационныхКарт,
		"ПоляШаблонаРегистрационнаяКарта");
	
	СтруктураДанных = Новый Структура;
	
	Если ЗначениеЗаполнено(Параметры.АдресВХранилище) Тогда
		
		СтруктураДанных = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
		
		Если СтруктураДанных.Свойство("Товары") Тогда
			Объект.ИсходныеДанные.Загрузить(СтруктураДанных.Товары);
			СтраницаПриОткрытии = "СтраницаТовары";
		ИначеЕсли СтруктураДанных.Свойство("ПодарочныеСертификаты") Тогда
			Объект.ПодарочныеСертификаты.Загрузить(СтруктураДанных.ПодарочныеСертификаты);
			СтраницаПриОткрытии = "СтраницаПодарочныеСертификаты";
			ЭтаФорма.АвтоЗаголовок = Ложь;
			ЭтаФорма.Заголовок = НСтр("ru = 'Печать этикеток подарочных сертификатов'");
		ИначеЕсли СтруктураДанных.Свойство("ДисконтныеКарты") Тогда
			Объект.ДисконтныеКарты.Загрузить(СтруктураДанных.ДисконтныеКарты);
			СтраницаПриОткрытии = "СтраницаДисконтныеКарты";
			ЭтаФорма.АвтоЗаголовок = Ложь;
			ЭтаФорма.Заголовок = НСтр("ru = 'Печать этикеток дисконтных карт'");
		ИначеЕсли СтруктураДанных.Свойство("РегистрационныеКарты") Тогда
			Объект.РегистрационныеКарты.Загрузить(СтруктураДанных.РегистрационныеКарты);
			СтраницаПриОткрытии = "СтраницаРегистрационныеКарты";
			ЭтаФорма.АвтоЗаголовок = Ложь;
			ЭтаФорма.Заголовок = НСтр("ru = 'Печать этикеток регистрационных карт'");
		ИначеЕсли СтруктураДанных.Свойство("Справки2ЕГАИС") Тогда
			Объект.ИсходныеДанные.Загрузить(СтруктураДанных.Справки2ЕГАИС);
			СтраницаПриОткрытии = "СтраницаТовары";
			ЭтаФорма.АвтоЗаголовок = Ложь;
			ЭтаФорма.Заголовок = НСтр("ru = 'Печать этикеток Справок 2 ЕГАИС'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтруктураДанных.СтруктураДействий) Тогда
			
			ПараметрДействия = Неопределено;
			
			Если СтруктураДанных.СтруктураДействий.Свойство("УстановитьРежим", ПараметрДействия) Тогда
				УстановитьРежим(ПараметрДействия);
			Иначе
				УстановитьРежим("ПечатьЭтикеток");
			КонецЕсли;
			
			Если СтруктураДанных.СтруктураДействий.Свойство("ИспользоватьСправкиБ", ПараметрДействия) Тогда
				Объект.ИспользоватьСправкиБ = ПараметрДействия;
				Элементы.ТоварыСправка2.Видимость = ПараметрДействия;
				Элементы.ТоварыШтрихСправкиБ.Видимость = ПараметрДействия;
			КонецЕсли;
			
			Если СтруктураДанных.СтруктураДействий.Свойство("ЗаполнитьСклад", ПараметрДействия) Тогда
				УстановитьЭлементОтбораСКД(КомпоновщикНастроек, "Склад", ПараметрДействия, Истина);
			КонецЕсли;
			
			СтруктураДанных.СтруктураДействий.Свойство("РежимПечатиИзОбработки", ПараметрДействия);
			Объект.ПечатьИзОбработки = ПараметрДействия;
			
			Если СтруктураДанных.СтруктураДействий.Свойство("ЗаполнитьМагазин", ПараметрДействия) Тогда
				
				Объект.Магазин = ПараметрДействия;
				МагазинПриИзмененииСервер();
				
			КонецЕсли;

			Если СтруктураДанных.СтруктураДействий.Свойство("ЗаполнитьПравилоЦенообразования", ПараметрДействия) Тогда
				Объект.ПравилоЦенообразования = ПараметрДействия;
			КонецЕсли;
			
			Если СтруктураДанных.СтруктураДействий.Свойство("ЗаполнитьВидЦены", ПараметрДействия) Тогда
				Объект.ВидЦены = ПараметрДействия;
			КонецЕсли;

			Если СтруктураДанных.СтруктураДействий.Свойство("УстановитьСпособПолученияЦен", ПараметрДействия) Тогда
				Объект.ЦеныПоВидуЦены = ПараметрДействия;
				ЦеныПоВидуЦены = Число(Объект.ЦеныПоВидуЦены);
			Иначе
				ЦеныПоВидуЦены = 0;
			КонецЕсли;

			Если СтруктураДанных.СтруктураДействий.Свойство("УстановитьСостояниеЦен", ПараметрДействия) Тогда
				Объект.ЦеныНазначенныеДействующие = ПараметрДействия;
				ЦеныНазначенныеДействующие = Число(Объект.ЦеныНазначенныеДействующие);
			КонецЕсли;
			
			Если СтруктураДанных.СтруктураДействий.Свойство("УстановитьДатуПолученияЦен", ПараметрДействия) Тогда
				
				Объект.ЦеныНаДату = ПараметрДействия;
				
			Иначе
				
				Объект.ЦеныНаДату = ТекущаяДатаСеанса();
				
			КонецЕсли;

			Если СтруктураДанных.СтруктураДействий.Свойство("ПоказыватьКолонкуКоличествоВДокументе", ПараметрДействия) Тогда
				Элементы.ТоварыКоличествоВДокументе.Видимость = ПараметрДействия;
			КонецЕсли;
			
			Если СтруктураДанных.СтруктураДействий.Свойство("УстановитьРежимПечатиИзДокумента", ПараметрДействия) Тогда
				Объект.ПечатьИзДокумента = Истина;
			КонецЕсли;
			
			ЗаполнитьКоличествоЭтикетокПоДокументу        = СтруктураДанных.СтруктураДействий.Свойство("ЗаполнитьКоличествоЭтикетокПоДокументу", ПараметрДействия);
			
			Если СтруктураДанных.СтруктураДействий.Свойство("СкрыватьКомандуЗаполненияПоДокументу", ПараметрДействия) Тогда
				Элементы.ЗаполнитьКоличествоЭтикетокПоДокументу.Видимость = Ложь;
				СкрыватьКомандуЗаполненияПоДокументу = Истина;
			КонецЕсли;
			
			Если СтруктураДанных.СтруктураДействий.Свойство("ЗаполнитьТаблицуТоваров", ПараметрДействия) Тогда
				
				Если Объект.ПечатьИзДокумента Тогда
					МассивДокументов = Новый Массив;
					СтруктураДанных.Свойство("МассивДокументов", МассивДокументов);
					СписокДокументов.ЗагрузитьЗначения(МассивДокументов);
				КонецЕсли;

				ЗаполнитьТаблицуТоваровНаСервере();
			КонецЕсли;
			
		КонецЕсли;
		
		Если Объект.ПечатьИзДокумента Тогда
			МассивДокументов = Новый Массив;
			СтруктураДанных.Свойство("МассивДокументов", МассивДокументов);
			СписокДокументов.ЗагрузитьЗначения(МассивДокументов);
		КонецЕсли;
		
	Иначе
		// Вызов обработки из интерфейса.
		
		ВосстановитьНастройкиНаСервере();
		Объект.Магазин = ОбщегоНазначенияРТ.ОпределитьТекущийМагазин();
		МагазинПриИзмененииСервер();
		Объект.ЦеныНаДату = ТекущаяДатаСеанса();
		ЗаполнитьКоличествоЭтикетокПоДокументу = Ложь;
		Если НЕ ЗначениеЗаполнено(Объект.Режим) Тогда
			УстановитьРежимПечатьЦенниковИЭтикетокНаСервере();
		КонецЕсли;
		
	КонецЕсли;
	
	ТипыИспользуемогоОборудования = МенеджерОборудованияВызовСервера.ТипыИспользуемогоОборудованияТекущегоРабочегоМеста();
	ИспользуетсяТСД = ложь;
	
	Элементы.ПодарочныеСертификатыЗагрузитьДанныеИзТСД.Видимость = ИспользуетсяТСД; 
	Элементы.ДисконтныеКартыЗагрузитьДанныеИзТСД.Видимость = ИспользуетсяТСД; 
	Элементы.РегистрационныеКартыЗагрузитьДанныеИзТСД.Видимость = ИспользуетсяТСД; 
	
	УстановитьВидимостьЭлементов();
	ИзменитьДоступностьЭлементовПриИзмененииЦеныПоВидуЦены();
	ОбновитьВидимостьЭлементов();
	ОбработкаТабличнойЧастиТоварыСервер.ЗаполнитьПризнакИспользованияХарактеристик(Объект.Товары);
	
	ИмяТаблицыВыборки = ИмяТаблицыВыборки(Элементы.СтраницыТиповПечати.ТекущаяСтраница.Имя);
	
	
	элементы.ТоварыШтрихкод.ТолькоПросмотр=Ложь;
	Орг=Справочники.ххх_Справочник.ОрганизацияТорговлиПивом.значение;
	Для каждого стр из Объект.товары Цикл
		стр.Организация=орг;
	КонецЦикла;

КонецПроцедуры

&НаСервере
&Вместо("УстановитьРежим")
Процедура КочетовУстановитьРежим(ПараметрРежим)
	Если ПараметрРежим = "ПечатьЦенниковИЭтикеток" Тогда
		УстановитьРежимПечатьЦенниковИЭтикетокНаСервере();
	ИначеЕсли ПараметрРежим = "ПечатьЦенников" или ПараметрРежим = "ПечатьИзменившихсяЦенников" Тогда
		УстановитьРежимПечатьЦенниковНаСервере();
	ИначеЕсли ПараметрРежим = "ПечатьЭтикеток" Тогда
		УстановитьРежимПечатьЭтикетокНаСервере();
	Иначе
		ВызватьИсключение НСтр("ru = 'Установленный режим печати не поддерживается'");
	КонецЕсли;
КонецПроцедуры





















