﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ТабельСтрокиПоСотруднику(ДанныеОВремени, НомерСтрокиСотрудник) Экспорт
	
	Возврат ДанныеОВремени.НайтиСтроки(Новый Структура("НомерСтрокиСотрудник", НомерСтрокиСотрудник));
	
КонецФункции

Функция ТабельОбозначенияВидовВремени(СоответствиеОбозначенийВидамВремени) Экспорт
	
	ОбозначенияВидовВремени = Новый Соответствие;
	Для Каждого КлючЗначение Из СоответствиеОбозначенийВидамВремени Цикл
		ОбозначенияВидовВремени.Вставить(КлючЗначение.Значение.ВидВремени, КлючЗначение.Ключ);
	КонецЦикла;
	
	Возврат ОбозначенияВидовВремени;
	
КонецФункции

Функция ДанныеОВремениСотрудников(ДанныеТабеля, СписокСотрудников = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Магазин", ДанныеТабеля.Магазин);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(ДанныеТабеля.ПериодРегистрации));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(ДанныеТабеля.ПериодРегистрации));

	Если СписокСотрудников = Неопределено Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ФактическоеРабочееВремяСотрудников.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	РегистрНакопления.ФактическоеРабочееВремяСотрудников КАК ФактическоеРабочееВремяСотрудников
		|ГДЕ
		|	ФактическоеРабочееВремяСотрудников.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ФактическоеРабочееВремяСотрудников.Магазин = &Магазин
		|";
		
		Запрос.Выполнить();
	
	Иначе
		
		ТаблицаСотрудников = Новый ТаблицаЗначений;
		ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
		
		Для каждого Сотрудник Из СписокСотрудников Цикл
			СтрокаТаблицы = ТаблицаСотрудников.Добавить();
			СтрокаТаблицы.Сотрудник = Сотрудник;
		КонецЦикла;
		
		Запрос.УстановитьПараметр("ТаблицаСотрудников", ТаблицаСотрудников);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаСотрудников.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	&ТаблицаСотрудников КАК ТаблицаСотрудников";
		
		Запрос.Выполнить();

	КонецЕсли;	

	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ФактическоеРабочееВремяСотрудников.Период КАК Дата,
	|	ФактическоеРабочееВремяСотрудников.Магазин КАК Магазин,
	|	ФактическоеРабочееВремяСотрудников.Сотрудник КАК Сотрудник,
	|	ВЫБОР
	|		КОГДА ФактическоеРабочееВремяСотрудников.НачалоРаботы 
	|		МЕЖДУ ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ФактическоеРабочееВремяСотрудников.НачалоРаботы, ДЕНЬ), ЧАС, 22)
	|		 И ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ФактическоеРабочееВремяСотрудников.НачалоРаботы, ДЕНЬ), ДЕНЬ, 1), ЧАС, 6)
	|			ТОГДА Значение(Перечисление.ВидыИспользованияРабочегоВремени.НочныеЧасы)
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ФактическоеРабочееВремяСотрудников.НачалоРаботы МЕЖДУ НАЧАЛОПЕРИОДА(ФактическоеРабочееВремяСотрудников.НачалоРаботы, ДЕНЬ) И ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ФактическоеРабочееВремяСотрудников.НачалоРаботы, ДЕНЬ), СЕКУНДА, 21599)
	|					ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыИспользованияРабочегоВремени.НочныеЧасы)
	|				ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыИспользованияРабочегоВремени.Явка)
	|			КОНЕЦ
	|	КОНЕЦ КАК ВидВремени,
	|	ФактическоеРабочееВремяСотрудников.РабочееВремяСотрудников КАК Часы
	|ИЗ
	|	(ВЫБРАТЬ
	|		ФактическоеРабочееВремяСотрудниковОбороты.Период КАК Период,
	|		ФактическоеРабочееВремяСотрудниковОбороты.Магазин КАК Магазин,
	|		ФактическоеРабочееВремяСотрудниковОбороты.Сотрудник КАК Сотрудник,
	|		ФактическоеРабочееВремяСотрудниковОбороты.РабочееВремяСотрудниковОборот КАК РабочееВремяСотрудниковОборот
	|	ИЗ
	|		РегистрНакопления.ФактическоеРабочееВремяСотрудников.Обороты(&НачалоПериода, &КонецПериода, День, Магазин = &Магазин) КАК ФактическоеРабочееВремяСотрудниковОбороты) КАК ВложенныйЗапрос
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ФактическоеРабочееВремяСотрудников КАК ФактическоеРабочееВремяСотрудников
	|		ПО ВложенныйЗапрос.Период = ФактическоеРабочееВремяСотрудников.Период
	|			И ВложенныйЗапрос.Магазин = ФактическоеРабочееВремяСотрудников.Магазин
	|			И ВложенныйЗапрос.Сотрудник = ФактическоеРабочееВремяСотрудников.Сотрудник
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудники КАК ВТСотрудники
	|		ПО ВложенныйЗапрос.Сотрудник = ВТСотрудники.Сотрудник
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	Дата,
	|	ВидВремени
	|";

	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

// Процедура заполняет заголовки полей таблицы "подневного" ввода данных,
// а также делает невидимыми колонки с 29 по 31 
// в зависимости от количества дней в выбранном месяце.
//
// Параметры:
//	ЭлементыФормы - коллекция элементов формы.
//	Месяц - дата, начало выбранного месяца.
//	ШаблонИмениПоля - строка, имя поля дня, в котором номер дня обозначен "%1".
//
Процедура ОформитьПоляТаблицыДнейМесяца(ЭлементыФормы, Месяц, ШаблонИмениПоля) Экспорт
	
	ЦветРабочегоДня = ЦветаСтиля.ЦветТекстаФормы;
	ЦветВыходногоДня = ЦветаСтиля.ЦветОсобогоТекста;
	
	ПоследнийДеньМесяца = День(КонецМесяца(Месяц));
	
	Для НомерДня = 1 По ПоследнийДеньМесяца Цикл
		
		ТекущийДень = Дата(Год(Месяц), Месяц(Месяц), НомерДня);
		
		ДеньНедели = ДеньНедели(ТекущийДень);
		
		Элемент = ЭлементыФормы[СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонИмениПоля, НомерДня)];
		Элемент.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								"%1%2%3", НомерДня, Символы.ПС, Формат(ТекущийДень, "ДФ=ддд"));
		Элемент.ЦветТекстаЗаголовка = ?(ДеньНедели = 6 Или ДеньНедели = 7, ЦветВыходногоДня, ЦветРабочегоДня);
		
	КонецЦикла;		
КонецПроцедуры	

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати – ТаблицаЗначений – состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Т-13
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "УнифицированнаяФормаТ13";
	КомандаПечати.Представление = НСтр("ru = 'Т-13'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм,
		"УнифицированнаяФормаТ13") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"УнифицированнаяФормаТ13",
			"Табель учета рабочего времени (Т-13)",
			СформироватьПечатнуюФормуТ13(МассивОбъектов,
				ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Магазин)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПечатнуюФормуТ13(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УНИФИЦИРОВАННАЯ_ФОРМА_Т_13";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_УнифицированнаяФормаТ13");
	
	ВыборкаДанныхОВремени = СформироватьЗапросДляПечати(МассивОбъектов);
	
	ШапкаДокумента = МассивОбъектов[0].Ссылка;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Организация = Справочники.Организации.ПолучитьОрганизациюПоУмолчанию();
	Иначе
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;

	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.ОрганизацияНаименование = Организация.Наименование;
	ОбластьШапка.Параметры.ОрганизацияКодПоОКПО = Организация.КодПоОКПО;
	ОбластьШапка.Параметры.ДатаЗаполнения = ШапкаДокумента.Дата;
	ОбластьШапка.Параметры.НомерДокумента = ШапкаДокумента.Номер;
	ОбластьШапка.Параметры.ДатаНачала = ШапкаДокумента.ПериодРегистрации;
	ОбластьШапка.Параметры.ДатаОкончания = КонецМесяца(ШапкаДокумента.ПериодРегистрации);
	ОбластьШапка.Параметры.ПодразделениеНаименование = ШапкаДокумента.Магазин.Наименование;
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	НомерСотрудника = 0;
	Пока ВыборкаДанныхОВремени.СледующийПоЗначениюПоля("Сотрудник") Цикл
		ОтработаноДнейЗаПервуюПоловинуМесяца = 0;
		ОтработаноЧасовЗаВторуюПоловинуМесяца = 0;
		ОтработаноДнейЗаВторуюПоловинуМесяца = 0;
		ОтработаноЧасовЗаПервуюПоловинуМесяца = 0;
		ОтработаноДнейЗаМесяц = 0;
		ОтработаноЧасовЗаМесяц = 0;
		
		НомерСотрудника = НомерСотрудника + 1;
		
		ОбластьДанныеОВремени = Макет.ПолучитьОбласть("Строка");
		
		ОбластьДанныеОВремени.Параметры.Сотрудник = ВыборкаДанныхОВремени.СотрудникНаименование;;	
		ОбластьДанныеОВремени.Параметры.НомерПП = НомерСотрудника;	
		
		ОтклоненияПоСотруднику = Новый ТаблицаЗначений;
		ОтклоненияПоСотруднику.Колонки.Добавить("ВидВремени");
		ОтклоненияПоСотруднику.Колонки.Добавить("БуквенныйКод");
		ОтклоненияПоСотруднику.Колонки.Добавить("Часов");
		ОтклоненияПоСотруднику.Колонки.Добавить("Дней");
		
		Пока ВыборкаДанныхОВремени.СледующийПоЗначениюПоля("Дата") Цикл 
			ПредставлениеВидовВремени = "";
			ЧасыПоВидамВремениСтрока = "";
			КоличествоЗаписейНаДату = 0;
			РабочийДень = Ложь;
			
			Пока ВыборкаДанныхОВремени.Следующий() Цикл
				Если Не ВыборкаДанныхОВремени.РабочееВремя Тогда
					
					ОтклоненияПоВидуВремени = ОтклоненияПоСотруднику.Добавить();
					
					ОтклоненияПоВидуВремени.ВидВремени = ВыборкаДанныхОВремени.ВидВремени;
					ОтклоненияПоВидуВремени.БуквенныйКод = ВыборкаДанныхОВремени.БуквенныйКод;
					ОтклоненияПоВидуВремени.Дней = 1;
					ОтклоненияПоВидуВремени.Часов = ВыборкаДанныхОВремени.Часов;
					
				КонецЕсли;
				
				ПредставлениеВидовВремени = ПредставлениеВидовВремени + "/"+  ВыборкаДанныхОВремени.БуквенныйКод;
				
				ЧасыПоВидамВремениСтрока = ЧасыПоВидамВремениСтрока +  "/" + Формат(ВыборкаДанныхОВремени.Часов, "ЧГ=");
				ОтработаноЧасовЗаМесяц = ОтработаноЧасовЗаМесяц + ВыборкаДанныхОВремени.Часов;
				
				Если День(ВыборкаДанныхОВремени.Дата) > 15 Тогда
					ОтработаноЧасовЗаВторуюПоловинуМесяца = ОтработаноЧасовЗаВторуюПоловинуМесяца + ВыборкаДанныхОВремени.Часов;
				Иначе
					ОтработаноЧасовЗаПервуюПоловинуМесяца = ОтработаноЧасовЗаПервуюПоловинуМесяца + ВыборкаДанныхОВремени.Часов;
				КонецЕсли;
				
				Если ВыборкаДанныхОВремени.РабочееВремя Тогда
					РабочийДень = Истина;
				КонецЕсли;
				
				КоличествоЗаписейНаДату = КоличествоЗаписейНаДату + 1;
				
			КонецЦикла;
			
			Если РабочийДень Тогда
				ОтработаноДнейЗаМесяц = ОтработаноДнейЗаМесяц + 1;
				Если День(ВыборкаДанныхОВремени.Дата) > 15 Тогда
					ОтработаноДнейЗаВторуюПоловинуМесяца = ОтработаноДнейЗаВторуюПоловинуМесяца + 1;
				Иначе
					ОтработаноДнейЗаПервуюПоловинуМесяца = ОтработаноДнейЗаПервуюПоловинуМесяца + 1;
				КонецЕсли;
			КонецЕсли;
			
			НомерДня = День(ВыборкаДанныхОВремени.Дата);
			
			ОбластьДанныеОВремени.Параметры["Символ" + НомерДня] = Сред(ПредставлениеВидовВремени, 2);
			ОбластьДанныеОВремени.Параметры["ДополнительноеЗначение"+ НомерДня] = Сред(ЧасыПоВидамВремениСтрока, 2);
			
		КонецЦикла;
		
		ОбластьДанныеОВремени.Параметры.ДниПерваяПоловина = ОтработаноДнейЗаПервуюПоловинуМесяца;
		ОбластьДанныеОВремени.Параметры.ЧасыПерваяПоловина = ОтработаноЧасовЗаПервуюПоловинуМесяца;
		ОбластьДанныеОВремени.Параметры.ДниВтораяПоловина = ОтработаноДнейЗаВторуюПоловинуМесяца;
		ОбластьДанныеОВремени.Параметры.ЧасыВтораяПоловина = ОтработаноЧасовЗаВторуюПоловинуМесяца;
		ОбластьДанныеОВремени.Параметры.ДниЗаМесяц = ОтработаноДнейЗаМесяц;
		ОбластьДанныеОВремени.Параметры.ЧасыЗаМесяц = ОтработаноЧасовЗаМесяц;
		
		ОтклоненияПоСотруднику.Свернуть("ВидВремени, БуквенныйКод", "Дней, Часов");
		
		СчОтклонений = 1;
		Для Каждого ОтклонениеПоВидуВремени Из ОтклоненияПоСотруднику Цикл
			Если СчОтклонений > 8 Тогда
				Прервать;
			КонецЕсли;
			
			ОбластьДанныеОВремени.Параметры["НеявкаКод" + СчОтклонений] = ОтклонениеПоВидуВремени.БуквенныйКод;
			ОбластьДанныеОВремени.Параметры["НеявкаДниЧасы" + СчОтклонений] = Формат(ОтклонениеПоВидуВремени.Дней, "ЧГ=") + 
			?(ОтклонениеПоВидуВремени.Часов > 0, "(" + Формат(ОтклонениеПоВидуВремени.Часов, "ЧГ=") + ")", "");
			
			СчОтклонений = СчОтклонений + 1;
		КонецЦикла;
		
		МассивОбластей = Новый Массив;
		МассивОбластей.Добавить(ОбластьДанныеОВремени);
		
		Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, МассивОбластей) Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			ТекущийЛист = Новый ТабличныйДокумент;
			ТекущийЛист.АвтоМасштаб = Истина;
			ТекущийЛист.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
			
			ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
			ТекущийЛист.Вывести(ОбластьШапкаТаблицы);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьДанныеОВремени);
	КонецЦикла;
	
	ОбластьПодвал.Параметры.Заполнить(ШапкаДокумента);
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДанныхОВремени.Ссылка);
	
	Возврат ТабличныйДокумент;
КонецФункции

Функция СформироватьЗапросДляПечати(МассивОбъектов)
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Сотрудник,
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка,
	|	МИНИМУМ(ТабельУчетаРабочегоВремениДанныеОВремени.НомерСтроки) КАК НомерСтроки
	|ПОМЕСТИТЬ ВТПорядокСотрудниковВДокументе
	|ИЗ
	|	Документ.ТабельУчетаРабочегоВремени.ДанныеОВремени КАК ТабельУчетаРабочегоВремениДанныеОВремени
	|ГДЕ
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка В(&МассивОбъектов)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Сотрудник,
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПорядокСотрудниковВДокументе.Сотрудник,
	|	ПорядокСотрудниковВДокументе.Ссылка.Дата КАК Период
	|ПОМЕСТИТЬ ВТСотрудникиДокументов
	|ИЗ
	|	ВТПорядокСотрудниковВДокументе КАК ПорядокСотрудниковВДокументе
	|";

	Запрос = Новый Запрос(ТекстЗапроса);
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Выполнить();

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка КАК Ссылка,
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Сотрудник КАК Сотрудник,
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Часов1 КАК Часов,
	|	ТабельУчетаРабочегоВремениДанныеОВремени.ВидВремени1 КАК ВидВремени,
	|	НАЧАЛОПЕРИОДА(ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка.ПериодРегистрации, МЕСЯЦ) КАК Дата,
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка.Дата КАК ДатаДокумента
	|ПОМЕСТИТЬ ВТДанныеОВремени
	|ИЗ
	|	Документ.ТабельУчетаРабочегоВремени.ДанныеОВремени КАК ТабельУчетаРабочегоВремениДанныеОВремени
	|ГДЕ
	|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка В(&МассивОбъектов)
	|	И ТабельУчетаРабочегоВремениДанныеОВремени.ВидВремени1 <> ЗНАЧЕНИЕ(Перечисление.ВидыИспользованияРабочегоВремени.ПустаяСсылка)
	|";
	
	Для Сч = 2 По 31 Цикл
		ТекстЗапроса = ТекстЗапроса + "
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка,
		|	ТабельУчетаРабочегоВремениДанныеОВремени.Сотрудник,
		|	ТабельУчетаРабочегоВремениДанныеОВремени.Часов" + Сч + ",
		|	ТабельУчетаРабочегоВремениДанныеОВремени.ВидВремени" + Сч + ",
		|	ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка.ПериодРегистрации, МЕСЯЦ), ДЕНЬ, " + Строка(Сч - 1) + "),
		|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка.Дата КАК ДатаДокумента
		|ИЗ
		|	Документ.ТабельУчетаРабочегоВремени.ДанныеОВремени КАК ТабельУчетаРабочегоВремениДанныеОВремени
		|ГДЕ
		|	ТабельУчетаРабочегоВремениДанныеОВремени.Ссылка В(&МассивОбъектов)
		|	И ТабельУчетаРабочегоВремениДанныеОВремени.ВидВремени" + Сч + " <> ЗНАЧЕНИЕ(Перечисление.ВидыИспользованияРабочегоВремени.ПустаяСсылка)";

	КонецЦикла;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.Выполнить();
	
	СоответствиеОписаниеВидовВремени = Новый Соответствие;
	СоответствиеОписаниеВидовВремени.Вставить("Я",ПредопределенноеЗначение("Перечисление.ВидыИспользованияРабочегоВремени.Явка"));
	СоответствиеОписаниеВидовВремени.Вставить("Б",ПредопределенноеЗначение("Перечисление.ВидыИспользованияРабочегоВремени.Больничный"));
	СоответствиеОписаниеВидовВремени.Вставить("Н",ПредопределенноеЗначение("Перечисление.ВидыИспользованияРабочегоВремени.НочныеЧасы"));
	СоответствиеОписаниеВидовВремени.Вставить("О",ПредопределенноеЗначение("Перечисление.ВидыИспользованияРабочегоВремени.Отпуск"));
	
	ОписаниеВидовВремени = Новый ФиксированноеСоответствие(СоответствиеОписаниеВидовВремени);
	
	тзОписаниеВидовВремени = Новый ТаблицаЗначений;
	тзОписаниеВидовВремени.Колонки.Добавить("Ключ", ОбщегоНазначения.ОписаниеТипаСтрока(1));
	тзОписаниеВидовВремени.Колонки.Добавить("Значение", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыИспользованияРабочегоВремени"));
	Для каждого ВидВремени Из ОписаниеВидовВремени Цикл
		НоваяСтрока = тзОписаниеВидовВремени.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВидВремени);
	КонецЦикла;
	
	ТекстЗапроса = " 
	|ВЫБРАТЬ *
	|ПОМЕСТИТЬ тзОписаниеВидовВремени
	|ИЗ
	|	&ОписаниеВидовВремени КАК ОписаниеВидовВремени
	|;
	|ВЫБРАТЬ
	|	ОписаниеВидовВремени.Ключ КАК БуквенныйКод,
	|	ОписаниеВидовВремени.Значение КАК ВидВремени
	|ПОМЕСТИТЬ ВТОписаниеВидовВремени
	|ИЗ
	|	тзОписаниеВидовВремени КАК ОписаниеВидовВремени
	|";

	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ОписаниеВидовВремени", тзОписаниеВидовВремени);
	Запрос.Выполнить();
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДанныеОВремени.Ссылка КАК Ссылка,
		|	ДанныеОВремени.Сотрудник КАК Сотрудник,
		|	ДанныеОВремени.Дата КАК Дата,
		|	ДанныеОВремени.ВидВремени,
		|	ДанныеОВремени.Часов,
		|	ОписаниеВидовВремени.БуквенныйКод,
		|	ВЫБОР
		|		КОГДА ОписаниеВидовВремени.ВидВремени = &Явка
		|		ИЛИ ОписаниеВидовВремени.ВидВремени = &НочныеЧасы
		|			ТОГДА Истина
		|		ИНАЧЕ Ложь
		|	КОНЕЦ КАК РабочееВремя,
		|	ВЫБОР
		|		КОГДА ОписаниеВидовВремени.ВидВремени = &Явка
		|			ТОГДА 1
		|		КОГДА ОписаниеВидовВремени.ВидВремени = &НочныеЧасы
		|			ТОГДА 2
		|		ИНАЧЕ 3
		|	КОНЕЦ КАК Приоритет,
		|	Сотрудники.Наименование КАК СотрудникНаименование
		|ИЗ
		|	ВТДанныеОВремени КАК ДанныеОВремени
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица КАК Сотрудники
		|		ПО ДанныеОВремени.Сотрудник = Сотрудники.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОписаниеВидовВремени КАК ОписаниеВидовВремени
		|		ПО ДанныеОВремени.ВидВремени = ОписаниеВидовВремени.ВидВремени
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПорядокСотрудниковВДокументе КАК ПорядокСотрудниковВДокументе
		|		ПО ДанныеОВремени.Сотрудник = ПорядокСотрудниковВДокументе.Сотрудник
		|			И ДанныеОВремени.Сотрудник = ПорядокСотрудниковВДокументе.Сотрудник
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	ПорядокСотрудниковВДокументе.НомерСтроки,
		|	Сотрудник,
		|	Дата,
		|	Приоритет
		|";

	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Явка", ПредопределенноеЗначение("Перечисление.ВидыИспользованияРабочегоВремени.Явка"));
	Запрос.УстановитьПараметр("НочныеЧасы", ПредопределенноеЗначение("Перечисление.ВидыИспользованияРабочегоВремени.НочныеЧасы"));
	                                
	Возврат Запрос.Выполнить().Выбрать();	
КонецФункции
#КонецОбласти

#КонецЕсли
