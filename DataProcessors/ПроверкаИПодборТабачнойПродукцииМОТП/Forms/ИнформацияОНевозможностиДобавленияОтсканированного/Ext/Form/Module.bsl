﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИдентификаторСтрокиПозиционирования = - 1;
	ПоказатьДерево                      = Ложь;
	СкрытьБезПроблем                    = Истина;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресХранилищаДереваУпаковки) Тогда
		
		ИнформацияВДереве = Истина;
		
		ДеревоУпаковки = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаДереваУпаковки);
		
		Для Каждого СтрокаДерева Из ДеревоУпаковки.Строки Цикл
			
			Если СтрокаДерева.КоличествоПачек > 0 Тогда
				ПоказатьДерево = Истина;
			КонецЕсли;
			
			ДобавитьСтрокуВДерево(ДеревоОтсканированнойУпаковки.ПолучитьЭлементы(), СтрокаДерева);
			
		КонецЦикла;
		
	Иначе 
		
		ИнформацияВДереве = Ложь;
		ЭтоУпаковка       = Ложь; 
		
	КонецЕсли;
	
	СброситьРазмерыИПоложениеОкна();
	
	Если ПоказатьДерево Тогда
		
		ПоказатьИнформациюОПроблемахСУпаковкой();
		
	Иначе
		
		ПоказатьИнформациюОПроблемахСТабачнойПродукцией(ИнформацияВДереве);
		
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОшибкаДобавленияТабачнойПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СкопироватьШтриховойКодВБуферОбмена" Тогда
		
		ИнтеграцияИСКлиент.СкопироватьШтрихКодВБуферОбмена(Элементы.БуферОбмена, ЗначениеКодаМаркировки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОтсканированнойУпаковки

&НаКлиенте
Процедура ДеревоОтсканированнойУпаковкиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоОтсканированнойУпаковки.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено 
		И ТекущиеДанные.ЕстьОшибки Тогда
		
		ТекстОшибки = ТекущиеДанные.ТекстОшибки;
		
	Иначе
		
		ТекстОшибки = "";
		
	КонецЕсли;
	
	Элементы.ДекорацияПредставлениеОшибкиТекущейСтроки.Заголовок = ТекстОшибки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкрытьСтрокиБезПроблем(Команда)
	
	СкрытьБезПроблем = Не СкрытьБезПроблем;
	Элементы.ДеревоОтсканированнойУпаковкиСкрытьСтрокиБезПроблем.Пометка = СкрытьБезПроблем;
	
	Если СкрытьБезПроблем Тогда
		СкрытьСтрокиБезПроблемНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьСтрокуВДерево(КоллекцияСтрокПриемника, СтрокаИсточник)

	НоваяСтрока = КоллекцияСтрокПриемника.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточник);
	ПроверкаИПодборПродукцииМОТПКлиентСервер.УстановитьИндексКартинкиТипаУпаковки(НоваяСтрока);
	
	Если НоваяСтрока.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
		КоличествоСтрокСТабачнойПродукцией = КоличествоСтрокСТабачнойПродукцией + 1;
	КонецЕсли;
	
	Если НоваяСтрока.ЕстьОшибки Тогда
		
		Если НоваяСтрока.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар Тогда
			КоличествоСтрокСПроблемами = КоличествоСтрокСПроблемами + 1;
		КонецЕсли;
		
		СтрокаРодитель = НоваяСтрока.ПолучитьРодителя();
		
		Если СтрокаРодитель <> Неопределено Тогда
			
			ИдентификаторСтрокиРодителя = СтрокаРодитель.ПолучитьИдентификатор();
			Если ИдентификаторыРаскрываемыхСтрок.НайтиПоЗначению(ИдентификаторСтрокиРодителя) = Неопределено Тогда
				ИдентификаторыРаскрываемыхСтрок.Добавить(ИдентификаторСтрокиРодителя);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИдентификаторСтрокиПозиционирования = - 1 Тогда
			ИдентификаторСтрокиПозиционирования = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ПодчиненнаяСтрока Из СтрокаИсточник.Строки Цикл
		
		ДобавитьСтрокуВДерево(НоваяСтрока.ПолучитьЭлементы(), ПодчиненнаяСтрока);
			
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ПодчиненнаяСтрока.ТипУпаковки) Тогда
			
			НоваяСтрока.СодержитУпаковок = НоваяСтрока.СодержитУпаковок + 1;
			
		Иначе 
			
			НоваяСтрока.СодержитПачек = НоваяСтрока.СодержитПачек + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(НоваяСтрока.ТипУпаковки) Тогда
		
		Для Каждого ПодчиненнаяСтрока Из НоваяСтрока.ПолучитьЭлементы() Цикл
			
			НоваяСтрока.СодержитУпаковок = НоваяСтрока.СодержитУпаковок + ПодчиненнаяСтрока.СодержитУпаковок;
			НоваяСтрока.СодержитПачек  = НоваяСтрока.СодержитПачек + ПодчиненнаяСтрока.СодержитПачек;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(НоваяСтрока.ТипУпаковки) Тогда
		
		Если НоваяСтрока.СодержитУпаковок > 0 
			И НоваяСтрока.СодержитПачек > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(НСтр("ru = 'Упаковок - %1, Пачек - %2.'"),
			                                      НоваяСтрока.СодержитУпаковок,
			                                      НоваяСтрока.СодержитПачек);
			
		ИначеЕсли НоваяСтрока.СодержитУпаковок > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(НСтр("ru = 'Упаковок - %1.'"),
			                                      НоваяСтрока.СодержитУпаковок);
			
		ИначеЕсли НоваяСтрока.СодержитПачек > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(НСтр("ru = 'Пачек - %1.'"),
			                                      НоваяСтрока.СодержитПачек);
			
		Иначе
			
			НоваяСтрока.ПредставлениеНоменклатуры = НСтр("ru = '<пустая упаковка>'");
			
		КонецЕсли;
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(НоваяСтрока.Номенклатура) Тогда
		НоваяСтрока.ПредставлениеНоменклатуры = НоваяСтрока.Номенклатура;
	Иначе
		НоваяСтрока.ПредставлениеНоменклатуры = НСтр("ru = '<не определена>'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
#Область ЕстьОшибки
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковкиТекстОшибки.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.ЕстьОшибки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблемаГосИС);

#КонецОбласти

#Область Отбор

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковки.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СкрытьБезПроблем");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.НеСоответствуетОтбору");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона" , ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);

#КонецОбласти

#Область Представление

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковкиПредставление.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.ТипУпаковки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыУпаковок.МаркированныйТовар;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);

#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура СкрытьСтрокиБезПроблемНаСервере()

	Если СкрытьБезПроблем Тогда
	
		СтрокиДерева = ДеревоОтсканированнойУпаковки.ПолучитьЭлементы();
		
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			
			СоответствуетОтбору = Ложь;
			СкрытьБезОшибокВСтрокеДерева(СтрокаДерева, СоответствуетОтбору);
			
		КонецЦикла;
		
		Элементы.ДеревоОтсканированнойУпаковкиСкрытьСтрокиБезПроблем.Пометка = СкрытьБезПроблем;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкрытьБезОшибокВСтрокеДерева(Знач СтрокаДерева, СоответствуетОтбору)

	Если ТипЗнч(СтрокаДерева) = Тип("Число") Тогда
		СтрокаДерева = ДеревоОтсканированнойУпаковки.НайтиПоИдентификатору(СтрокаДерева);
	КонецЕсли;
	
	ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();

	ТекущаяСтрокаСоотвествуетОтбору = Ложь;
	
	Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
		
		СоответствуетОтбору = Ложь;
		
		СкрытьБезОшибокВСтрокеДерева(ПодчиненнаяСтрока, СоответствуетОтбору);
		
		Если СоответствуетОтбору Тогда
			ТекущаяСтрокаСоотвествуетОтбору = Истина;
		КонецЕсли;
		
	КонецЦикла;

	Если Не ТекущаяСтрокаСоотвествуетОтбору Тогда
		
		ТекущаяСтрокаСоотвествуетОтбору = СтрокаДерева.ЕстьОшибки;
		
	КонецЕсли;
	
	СоответствуетОтбору = ТекущаяСтрокаСоотвествуетОтбору;
	СтрокаДерева.НеСоответствуетОтбору = Не СоответствуетОтбору;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого ЭлементСписка Из ИдентификаторыРаскрываемыхСтрок Цикл
		
		Элементы.ДеревоОтсканированнойУпаковки.Развернуть(ЭлементСписка.Значение, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьИнформациюОПроблемах()
	
	ШаблонСообщения = НСтр("ru = 'Добавление отсканированной упаковки невозможно. Невозможно добавить единиц Табачной продукции %1 из %2.'");
	Элементы.ДекорацияИнформацияОПроблемах.Заголовок = СтрШаблон(ШаблонСообщения, КоличествоСтрокСПроблемами, КоличествоСтрокСТабачнойПродукцией);
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ИнформацияОНевозможностиДобавленияОтсканированного", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПроблемахСТабачнойПродукцией(ИнформацияВДереве)

	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаТабачнаяПродукция;
	Элементы.СтраницаУпаковка.Видимость    = Ложь;
	
	ЭтотОбъект.Ширина = 50;
	ЭтотОбъект.Высота = 10;
	
	Элементы.ЗакрытьТабачнаяПродукция.КнопкаПоУмолчанию = Истина;
	
	Если ИнформацияВДереве Тогда
	
		СтрокиВерхнегоУровня = ДеревоОтсканированнойУпаковки.ПолучитьЭлементы();
		Если СтрокиВерхнегоУровня.Количество() = 0 Тогда
			
			Элементы.ДекорацияОшибкаДобавленияТабачнойПродукции.Заголовок = НСтр("ru = 'Нет информации по отсканированному штрихкоду'");
			Возврат;
			
		Иначе
			
			ДаннныеТабачнойПродукции = СтрокиВерхнегоУровня[0];
			
			ЗначениеКодаМаркировки = ДаннныеТабачнойПродукции.ЗначениеШтрихкода;
			ТабачнаяПродукция      = ДаннныеТабачнойПродукции.Номенклатура;
			ТекстОшибки            = ДаннныеТабачнойПродукции.ТекстОшибки;
			
		КонецЕсли;
		
	Иначе
		
		Если Параметры.Свойство("АдресДанныхШтрихкода") И ЭтоАдресВременногоХранилища(Параметры.АдресДанныхШтрихкода) Тогда
			ДанныеШтрихкода = ПолучитьИзВременногоХранилища(Параметры.АдресДанныхШтрихкода);
		Иначе
			ДанныеШтрихкода = Параметры.ДанныеШтрихкода;
		КонецЕсли;
		
		ТекстОшибки            = ДанныеШтрихкода.ТекстОшибки;
		ЗначениеКодаМаркировки = ?(ДанныеШтрихкода.Свойство("ЗначениеШтрихкода"), ДанныеШтрихкода.ЗначениеШтрихкода, ДанныеШтрихкода.Штрихкод);
		
		ТабачнаяПродукция = ?(ЗначениеЗаполнено(ДанныеШтрихкода.Номенклатура), 
			ДанныеШтрихкода.Номенклатура, 
			ДанныеШтрихкода.ПредставлениеНоменклатуры);
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТабачнаяПродукция) Тогда
		Префикс = СтрШаблон(
			НСтр("ru = 'Невозможно добавить табачную продукцию ""%1"" с кодом маркировки'"),
			ТабачнаяПродукция);
	Иначе
		Префикс = НСтр("ru = 'Невозможно добавить неопознанную табачную продукцию с кодом маркировки'");
	КонецЕсли;
	
	ТекстЗаголовка = Новый ФорматированнаяСтрока(
		Префикс, " ",
		Новый ФорматированнаяСтрока(
			ИнтеграцияИСКлиентСервер.ПредставлениеШтрихкода(ЗначениеКодаМаркировки),
			Новый Шрифт(,,,,Истина),
			ЦветаСтиля.ЦветГиперссылкиГосИС,,
			"СкопироватьШтриховойКодВБуферОбмена"), " ",
		СтрШаблон(
			НСтр("ru = 'по причине:
			           |%1'"), ТекстОшибки));
	
	ВысотаЗаголовка = СтрРазделить(ТекстЗаголовка, Символы.ПС).Количество();
	Если ВысотаЗаголовка > 12 Тогда
		ВысотаЗаголовка = 12;
	КонецЕсли;
	
	Элементы.ДекорацияОшибкаДобавленияТабачнойПродукции.Заголовок = ТекстЗаголовка;
	Элементы.ДекорацияОшибкаДобавленияТабачнойПродукции.Высота    = ВысотаЗаголовка;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПроблемахСУпаковкой()
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаУпаковка;
	Элементы.СтраницаТабачнаяПродукция.Видимость = Ложь;
	
	ЭтотОбъект.Ширина = 200;
	ЭтотОбъект.Высота = 40;
	
	СкрытьСтрокиБезПроблемНаСервере();
	СформироватьИнформациюОПроблемах();
	
	Элементы.ДеревоОтсканированнойУпаковки.ТекущаяСтрока = ИдентификаторСтрокиПозиционирования;
	
КонецПроцедуры

#КонецОбласти
