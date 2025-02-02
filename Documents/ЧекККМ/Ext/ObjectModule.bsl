﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПеременныеМодуля

Перем РежимРМК Экспорт; // Переменная, указывающая что проведение чека производится из режима регистрации продаж.

Перем КонтролироватьОстаткиТоваровПриЗакрытииЧека Экспорт;// Переменная хранит признак контроля остатков при закрытии
                                                          // чека.

Перем мЗакрытиеСмены Экспорт;// Переменная определяет режим в котором происходит запись документа.

Перем мСоответствиеТиповСкладов;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СоздатьЧекПродажи = Ложь;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("ДанныеЗаполнения") Тогда
			СоздатьЧекПродажи = ДанныеЗаполнения.Свойство("СоздатьЧекПродажи");
			ДанныеЗаполнения  = ДанныеЗаполнения.ДанныеЗаполнения;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЧекККМ") Тогда
		Если ДанныеЗаполнения.ВидОперации = Перечисления.ВидыОперацийЧекККМ.Продажа Тогда
			ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
			ПроверитьВозможностьВводаНаОснованииЧекаККМ(ДанныеЗаполнения);
			
			Если СоздатьЧекПродажи Тогда
				Если ДанныеЗаполнения.ОперацияСДенежнымиСредствами
					И ЗначениеЗаполнено(ДанныеЗаполнения.ДокументРасчета) Тогда
						ТесктИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																		НСтр("ru = 'По документу %1 не нужно вводить чек ККМ.'"), ДанныеЗаполнения);
						
						ВызватьИсключение ТесктИсключения;
				КонецЕсли;
				
				ДокументРасчета = ДанныеЗаполнения;
				ОперацияСДенежнымиСредствами = НЕ ДанныеЗаполнения.ОперацияСДенежнымиСредствами;
				
				Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения.ДокументРасчета) И 
					ДанныеЗаполнения.ОперацияСДенежнымиСредствами Тогда
					
					ЗаполнитьЗачетАванса();
					
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, "ВладелецДисконтнойКарты, ДисконтнаяКарта, КассаККМ, Организация, СуммаДокумента, Магазин, Продавец, ЦенаВключаетНДС, ЗаказПокупателя, СистемаНалогообложения, Контрагент");
				
				ЧекККМПродажа   = Документы.ЧекККМ.ПустаяСсылка();
				ВидОперации     = Перечисления.ВидыОперацийЧекККМ.Продажа;
				
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.Товары, Товары);
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.Подарки, Подарки);
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.Серии, Серии);
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.СерииПодарков, СерииПодарков);
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.СкидкиНаценки, СкидкиНаценки);
			Иначе
				Если ДанныеЗаполнения.ОперацияСДенежнымиСредствами Тогда
					Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения.ДокументРасчета) Тогда
						// Аванс
						ДокументРасчета = ДанныеЗаполнения;
					Иначе
						// Постоплата
						ДокументРасчета = ДанныеЗаполнения.ДокументРасчета;
					КонецЕсли;
					ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.СкидкиНаценки, СкидкиНаценки);
				КонецЕсли;
				
				ЧекККМПродажа = ДанныеЗаполнения;
				
				ОперацияСДенежнымиСредствами = ДанныеЗаполнения.ОперацияСДенежнымиСредствами;
				
				СтрокаЗаполнения = "ВладелецДисконтнойКарты,
								   |ДисконтнаяКарта,
								   |КассаККМ, 
								   |Организация, 
								   |СуммаДокумента, 
								   |Магазин, 
								   |Продавец, 
								   |ЦенаВключаетНДС, 
								   |ЗаказПокупателя, 
								   |СистемаНалогообложения, 
								   |Контрагент,
								   |ДоговорПлатежногоАгента";
				
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, СтрокаЗаполнения);
				
				ВидОперации     = Перечисления.ВидыОперацийЧекККМ.Возврат;
				ДисконтнаяКарта = ДанныеЗаполнения.ДисконтнаяКарта;
				
				ВладелецДисконтнойКарты = ДанныеЗаполнения.ВладелецДисконтнойКарты;
				
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.Товары, Товары);
				ЗапасыСервер.УдалитьПодарочныеСертификаты(Товары);
				
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.Подарки, Подарки);
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.Серии, Серии);
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеЗаполнения.СерииПодарков, СерииПодарков);
				
				Если НЕ ОперацияСДенежнымиСредствами Тогда
					ЗапросОплата = Новый Запрос(
					"ВЫБРАТЬ
					|	ЧекККМОплата.ВидОплаты КАК ВидОплаты,
					|	ЧекККМОплата.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
					|	СУММА(ЧекККМОплата.Сумма) КАК Сумма,
					|	ЧекККМОплата.ПроцентКомиссии КАК ПроцентКомиссии,
					|	СУММА(ЧекККМОплата.СуммаКомиссии) КАК СуммаКомиссии,
					|	ЧекККМОплата.СсылочныйНомер КАК СсылочныйНомер,
					|	ЧекККМОплата.НомерЧекаЭТ КАК НомерЧекаЭТ,
					|	ЧекККМОплата.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
					|	ЛОЖЬ КАК ДанныеПереданыВБанк
					|ПОМЕСТИТЬ ТаблицаОплатЧекаПродаж
					|ИЗ
					|	Документ.ЧекККМ.Оплата КАК ЧекККМОплата
					|ГДЕ
					|	ЧекККМОплата.Ссылка = &Ссылка
					|	И ЧекККМОплата.ВидОплаты.ТипОплаты = &ТипОплаты
					|
					|СГРУППИРОВАТЬ ПО
					|	ЧекККМОплата.ВидОплаты,
					|	ЧекККМОплата.ЭквайринговыйТерминал,
					|	ЧекККМОплата.ПроцентКомиссии,
					|	ЧекККМОплата.СсылочныйНомер,
					|	ЧекККМОплата.НомерЧекаЭТ,
					|	ЧекККМОплата.НомерПлатежнойКарты
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ РАЗЛИЧНЫЕ
					|	ТаблицаОплатЧекаПродаж.ВидОплаты,
					|	ТаблицаОплатЧекаПродаж.ЭквайринговыйТерминал
					|ПОМЕСТИТЬ ТаблицаВидовОплат
					|ИЗ
					|	ТаблицаОплатЧекаПродаж КАК ТаблицаОплатЧекаПродаж
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ТаблицаВидовОплат.ВидОплаты,
					|	ТаблицаВидовОплат.ЭквайринговыйТерминал,
					|	ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ПроцентКомиссииПриОтмене
					|ПОМЕСТИТЬ ТаблицаПроцентовКомиссииПриОтмене
					|ИЗ
					|	ТаблицаВидовОплат КАК ТаблицаВидовОплат
					|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЭквайринговыеТерминалы.ТарифыЗаРасчетноеОбслуживание КАК ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание
					|		ПО ТаблицаВидовОплат.ЭквайринговыйТерминал = ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.Ссылка
					|			И ТаблицаВидовОплат.ВидОплаты = ЭквайринговыеТерминалыТарифыЗаРасчетноеОбслуживание.ВидОплаты
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	ТаблицаОплатЧекаПродаж.ВидОплаты,
					|	ТаблицаОплатЧекаПродаж.ЭквайринговыйТерминал,
					|	ТаблицаОплатЧекаПродаж.Сумма,
					|	ВЫБОР
					|		КОГДА ТаблицаПроцентовКомиссииПриОтмене.ВидОплаты ЕСТЬ NULL 
					|			ТОГДА -ТаблицаОплатЧекаПродаж.ПроцентКомиссии
					|		ИНАЧЕ ТаблицаПроцентовКомиссииПриОтмене.ПроцентКомиссииПриОтмене
					|	КОНЕЦ КАК ПроцентКомиссии,
					|	ВЫБОР
					|		КОГДА ТаблицаПроцентовКомиссииПриОтмене.ВидОплаты ЕСТЬ NULL 
					|			ТОГДА -ТаблицаОплатЧекаПродаж.СуммаКомиссии
					|		ИНАЧЕ ТаблицаПроцентовКомиссииПриОтмене.ПроцентКомиссииПриОтмене * ТаблицаОплатЧекаПродаж.Сумма / 100
					|	КОНЕЦ КАК СуммаКомиссии,
					|	ТаблицаОплатЧекаПродаж.СсылочныйНомер,
					|	ТаблицаОплатЧекаПродаж.НомерЧекаЭТ,
					|	ТаблицаОплатЧекаПродаж.НомерПлатежнойКарты,
					|	ТаблицаОплатЧекаПродаж.ДанныеПереданыВБанк
					|ИЗ
					|	ТаблицаОплатЧекаПродаж КАК ТаблицаОплатЧекаПродаж
					|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПроцентовКомиссииПриОтмене КАК ТаблицаПроцентовКомиссииПриОтмене
					|		ПО ТаблицаОплатЧекаПродаж.ВидОплаты = ТаблицаПроцентовКомиссииПриОтмене.ВидОплаты
					|			И ТаблицаОплатЧекаПродаж.ЭквайринговыйТерминал = ТаблицаПроцентовКомиссииПриОтмене.ЭквайринговыйТерминал");
					
					ЗапросОплата.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
					ЗапросОплата.УстановитьПараметр("ТипОплаты", Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта);
					Результат = ЗапросОплата.Выполнить();
					ВыборкаОплата = Результат.Выбрать();
					ТаблицаОплат = Результат.Выгрузить();
					
					Пока ВыборкаОплата.Следующий() Цикл
						
						НоваяСтрокаОплаты = Оплата.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяСтрокаОплаты, ВыборкаОплата);
						
					КонецЦикла;
				Иначе
					ЗапросОплата = Новый Запрос;
					ЗапросОплата.Текст = 
					"ВЫБРАТЬ
					|	ЧекККМОплата.ВидОплаты КАК ВидОплаты,
					|	ЧекККМОплата.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
					|	ЧекККМОплата.Сумма КАК Сумма,
					|	ЧекККМОплата.ПроцентКомиссии КАК ПроцентКомиссии,
					|	ЧекККМОплата.СуммаКомиссии КАК СуммаКомиссии,
					|	ЧекККМОплата.СсылочныйНомер КАК СсылочныйНомер,
					|	ЧекККМОплата.НомерЧекаЭТ КАК НомерЧекаЭТ,
					|	ЧекККМОплата.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
					|	ЧекККМОплата.ДанныеПереданыВБанк КАК ДанныеПереданыВБанк,
					|	ЧекККМОплата.СуммаБонусовВСкидках КАК СуммаБонусовВСкидках,
					|	ЧекККМОплата.КоличествоБонусов КАК КоличествоБонусов,
					|	ЧекККМОплата.КоличествоБонусовВСкидках КАК КоличествоБонусовВСкидках,
					|	ЧекККМОплата.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
					|	ЧекККМОплата.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
					|	ЧекККМОплата.КлючСвязиОплаты КАК КлючСвязиОплаты
					|ИЗ
					|	Документ.ЧекККМ.Оплата КАК ЧекККМОплата
					|ГДЕ
					|	ЧекККМОплата.Ссылка = &Ссылка
					|	И ЧекККМОплата.ВидОплаты.ТипОплаты = &ТипОплаты";
					
					ЗапросОплата.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
					ЗапросОплата.УстановитьПараметр("ТипОплаты", Перечисления.ТипыОплатЧекаККМ.ВРассрочку);
					Результат = ЗапросОплата.Выполнить();
					ТаблицаОплат = Результат.Выгрузить();
					
					Оплата.Загрузить(ТаблицаОплат);
				КонецЕсли;
			КонецЕсли;
		Иначе
			
			ТесктИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
															НСтр("ru = 'По документу %1 нельзя чек ККМ.'"), ДанныеЗаполнения);
			
			ВызватьИсключение ТесктИсключения;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		
		ОбщегоНазначенияРТ.ПроверитьВозможностьВводаНаОсновании(ДанныеЗаполнения);
		
		Если ДанныеЗаполнения.Статус = Перечисления.СтатусыЗаказовПокупателей.НеСогласован Тогда
			ТекстОшибки = НСтр("ru='Заказ не согласован.
			|Заполнение документа не выполнено.'");
			
			ВызватьИсключение ТекстОшибки;
		ИначеЕсли ДанныеЗаполнения.Статус = Перечисления.СтатусыЗаказовПокупателей.Закрыт Тогда
			ТекстОшибки = НСтр("ru='Заказ закрыт.
			|Заполнение документа не выполнено.'");
			
			ВызватьИсключение ТекстОшибки;
			
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, "Магазин, ДисконтнаяКарта, ЦенаВключаетНДС, ВладелецДисконтнойКарты, Организация, Продавец, Контрагент");
		
		ЗаказПокупателя = ДанныеЗаполнения.Ссылка;
		ВидОперации     = Перечисления.ВидыОперацийЧекККМ.Продажа;
		
		РозничныеПродажиСервер.ЗаполнитьПоОстаткамЗаказа(ЭтотОбъект, ЗаказПокупателя);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") 
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОплатаОтПокупателяПлатежнойКартой") Тогда
		
		Если НЕ ДанныеЗаполнения.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
			ТекстОшибки = НСтр("ru='Чек можно создать только на основании поступления оплаты от клиента'");
			
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, "ЗаказПокупателя, КассаККМ, Организация, СистемаНалогообложения, Контрагент");
		
		ДокументРасчета = ДанныеЗаполнения;
		Магазин = КассаККМ.Магазин;
		
		Если НЕ ЗначениеЗаполнено(Магазин) Тогда
			
			Магазин = ДанныеЗаполнения.Касса.Магазин;
			
		КонецЕсли;
		
		ЗаполнитьЗачетАванса();
		
	ИначеЕсли НЕ ДанныеЗаполнения = Неопределено Тогда
		
		ИспользоватьЗаказыПокупателей = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПокупателей");
		
		Если ИспользоватьЗаказыПокупателей Тогда
			ТекстОшибки = НСтр("ru='Ввод на основании осуществляется для оформления возврата по чеку ККМ или для оформления продажи по заказу покупателя.
				|Заполнение документа не выполнено.'");
		Иначе
			ТекстОшибки = НСтр("ru='Ввод на основании осуществляется для оформления возврата по чеку ККМ.
				|Заполнение документа не выполнено.'");
		КонецЕсли;
			
		ВызватьИсключение ТекстОшибки;
			
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ОбщегоНазначенияРТ.ПроверитьИспользованиеОрганизации(,,Организация);
	
	Если Товары.Количество() > 0 Тогда
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// &ЗамерПроизводительности
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	
	Если мЗакрытиеСмены Тогда
		ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
		ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
		Возврат;
	ИначеЕсли ДополнительныеСвойства.Свойство("ЗагрузкаДанныхИзРабочегоМеста") Тогда
		Если СтатусЧекаККМ = Перечисления.СтатусыЧековККМ.Архивный
			ИЛИ СтатусЧекаККМ = Перечисления.СтатусыЧековККМ.Аннулированный Тогда
			ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
			ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	ИспользуетсяКомиссионнаяТорговля = ДополнительныеСвойства.ИспользуетсяКомиссионнаяТорговля;
	ИспользуетсяУчетИмпортныхТоваров = ДополнительныеСвойства.ИспользуетсяУчетИмпортныхТоваров;
	
	Документы.ЧекККМ.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПродажиСервер.ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоДисконтнымКартам(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьПродажиПоПлатежнымКартам(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	
	Если ИспользуетсяКомиссионнаяТорговля 
		ИЛИ ИспользуетсяУчетИмпортныхТоваров Тогда
		ЗапасыСервер.ОтразитьТоварыОрганизаций(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
	ЗапасыСервер.ОтразитьДвиженияСерийныхНомеров(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваККМ(ДополнительныеСвойства, Движения, Отказ);
	ПродажиСервер.ОтразитьЗаказыПокупателей(ДополнительныеСвойства, Движения, Отказ);
	БонусныеБаллыСервер.ОтразитьБонусныеБаллы(ДополнительныеСвойства, Движения, Отказ);
	ДенежныеСредстваСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля(ДополнительныеСвойства);
	
	// Запись наборов записей
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	ПроведениеСервер.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени("ЧекККМПроведение",ВремяНачалаЗамера,Товары.Количество(), "Вес по табличной части ""Товары""");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "Подарки");
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Склад");
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ,Новый Структура("ИмяТЧ","Подарки"));
	
	ПараметрыУказанияСерий = Документы.ЧекККМ.ПараметрыУказанияСерий(ЭтотОбъект);
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий, Отказ);
	
	ПараметрыУказанияСерий.Вставить("ИмяТЧТовары", "Подарки");
	ПараметрыУказанияСерий.Вставить("ИмяТЧСерии", "СерииПодарков");
	
	ОбработкаТабличнойЧастиТоварыСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий, Отказ);
	
	Если ЗначениеЗаполнено(КассаККМ)  Тогда
		
		СтруктураСостояниеКассовойСмены = РозничныеПродажиСервер.ПолучитьСостояниеКассовойСмены(КассаККМ);
		
		КассоваяСмена = СтруктураСостояниеКассовойСмены.КассоваяСмена;
		
		ТекстОшибки = НСтр("ru='Кассовая смена не открыта!'");
		Если НЕ РозничныеПродажиСервер.СменаОткрыта(КассоваяСмена, Дата, ТекстОшибки) Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				"КассаККМ",
				,
				Отказ
			);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИспользуетсяРегистрацияРозничныхПродажВЕГАИС = ИнтеграцияЕГАИСВызовСервера.ИспользуетсяРегистрацияРозничныхПродажВЕГАИС(Организация, Магазин, Дата);
	
	Если ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат Тогда
		МаркетинговыеАкцииСервер.ПроверитьЧтоНетПодарочныхСертификатов(
			ЭтотОбъект,
			"Товары",
			Отказ
		);
		
		МаркетинговыеАкцииСервер.ПроверитьЧтоНетОплатыПодарочнымСертификатом(
			ЭтотОбъект,
			"Оплата",
			Отказ
		);
		
		ПродажиСервер.ПроверитьВозможностьВозвратаПоЧекуККМ(
			ЭтотОбъект,
			Отказ,,,,,
			ИспользуетсяРегистрацияРозничныхПродажВЕГАИС
		);
		
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект.ЧекККМПродажа.ОтчетОРозничныхПродажах) Тогда // возврат день в день
			
			ПродажиСервер.ПроверитьВозможностьПровестиОплатуПоВозвратуЧекККМ(
				ЭтотОбъект,
				Отказ
			);
			
		КонецЕсли;
		
	Иначе
		
		ПродажиСервер.ПроверитьЗаполнениеСклада(
			ЭтотОбъект,
			"Товары",
			Отказ
		);
		
		МаркетинговыеАкцииСервер.ПроверитьЦеныСертификатов(
			ЭтотОбъект,
			"Товары",
			Отказ
		);
		
		Если НЕ ЗначениеЗаполнено(ЗаказПокупателя) Тогда
			МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиСерийныеНомера(
				ЭтотОбъект,
				"Товары",
				"СерийныеНомера",
				Отказ
			);
		КонецЕсли;
		
		МаркетинговыеАкцииСервер.ПроверитьЗаполнениеТабличнойЧастиПогашениеПодарочныхСертификатов(
			ЭтотОбъект,
			"ПогашениеПодарочныхСертификатов",
			Отказ);
		
		Если НЕ ОперацияСДенежнымиСредствами Тогда
			МаркетинговыеАкцииСервер.ПроверитьДвиженияСерийныхНомеров(
				ЭтотОбъект,
				"Товары",
				"СерийныеНомера",
				Отказ);
		КонецЕсли;
		
		МаркетинговыеАкцииСервер.ПроверитьОкончаниеАбсолютныхСроковДействияСертификатов(
			ЭтотОбъект,
			"Товары",
			Отказ);
		
		МаркетинговыеАкцииСервер.ПроверитьДвиженияСерийныхНомеровДляПогашения(
			ЭтотОбъект,
			"ПогашениеПодарочныхСертификатов",
			Отказ);
			
		Если НЕ ЗначениеЗаполнено(ЗаказПокупателя) Тогда
			АссортиментСервер.ПроверитьАссортиментТаблицыТоваровДокументаПродажи(
				ЭтотОбъект,
				Отказ,
				Истина);
		КонецЕсли;
		
		СкидкиНаценкиСерверПереопределяемый.ПроверитьЗапретРозничнойПродажиТаблицыТоваров(
			ЭтотОбъект,
			"Товары",
			Отказ);
			
			
		Если ЭтотОбъект.АкцизныеМарки.Количество() > 0 Тогда 
			СтруктураДляПроверки = ПродажиСервер.СтруктураДляПроверкиАкцизныхМарок();
			СтруктураДляПроверки.Объект 			= ЭтотОбъект;
			СтруктураДляПроверки.ИмяТаблицыТоваров 	= "АкцизныеМарки";
			СтруктураДляПроверки.Отказ 				= Отказ;
			СтруктураДляПроверки.ОрганизацияЕГАИС 	= Справочники.КлассификаторОрганизацийЕГАИС.ОрганизацияЕГАИСПоОрганизацииИТорговомуОбъекту(
														Организация, Магазин);
			
			ПродажиСервер.ПроверитьАкцизныеМаркиПередЗаписьюЧека(СтруктураДляПроверки);
			Если СтруктураДляПроверки.Отказ Тогда 
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
			
		МассивНепроверяемыхРеквизитов.Добавить("ЧекККМПродажа");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаХозяйственнойОперации");
		
	КонецЕсли;
	
	ТипОборудования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КассаККМ, "ПодключаемоеОборудование.ТипОборудования");
	Если ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ Тогда
		ПродажиСервер.ПроверитьОтсутствиеРазличныхРежимовНалогообложения(ЭтотОбъект, Отказ);
		ПродажиСервер.ПроверитьОтсутствиеРазличныхДоговоровПлатежныхАгентов(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ИспользуетсяТабачнаяМаркировка = ПолучитьФункциональнуюОпцию("ВестиУчетТабачнойПродукцииМОТП");
	ИспользуетсяОбувнаяМаркировка  = ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиОбувнойПродукции");
	
	Если НЕ ОперацияСДенежнымиСредствами И 
		(ИспользуетсяРегистрацияРозничныхПродажВЕГАИС ИЛИ ИспользуетсяТабачнаяМаркировка ИЛИ ИспользуетсяОбувнаяМаркировка) Тогда
		ДанныеЕГАИСДостаточны = Истина;
		ПродажиСервер.ПодготовкаДанныхДляПробитияЧекаККМ(ЭтотОбъект, ДанныеЕГАИСДостаточны);
		Если НЕ ДанныеЕГАИСДостаточны Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Документы.ЧекККМ.ВозможностьПустойТЧТовары(ЭтотОбъект) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// В погашении только подарочные сертификаты.
	ПродажиСервер.ПроверитьЗаполнениеТабличнойЧастиОплата(
		ЭтотОбъект,
		Отказ
	);
	
	
	// В погашении только подарочные сертификаты.
	МаркетинговыеАкцииСервер.ПроверитьТабличнуюЧастьПогашения(
		ЭтотОбъект,
		Отказ
	);
	
	МаркетинговыеАкцииСервер.ПроверитьЧтоНетПодарочныхСертификатов(
		ЭтотОбъект,
		"Подарки",
		Отказ
	);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеСервер.УстановитьРежимПроведения(Проведен, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СтатусЧекаККМПоСсылке = СтатусЧекаККМПоСсылке(Ссылка);
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Контрагент = Константы.КонтрагентРозничныйПокупатель.Получить();
	КонецЕсли;
	
	Если Не РежимРМК
	 И СтатусЧекаККМПоСсылке = Перечисления.СтатусыЧековККМ.Отложенный
	 И НЕ ДополнительныеСвойства.Свойство("ЗагрузкаДанныхИзРабочегоМеста") Тогда
		
		СтатусЧекаККМ = Перечисления.СтатусыЧековККМ.ПустаяСсылка();
		
	КонецЕсли;
	
	Если ((СтатусЧекаККМПоСсылке = Перечисления.СтатусыЧековККМ.Пробитый
	 И Не мЗакрытиеСмены)
	 ИЛИ СтатусЧекаККМПоСсылке = Перечисления.СтатусыЧековККМ.Архивный
	 ИЛИ СтатусЧекаККМПоСсылке = Перечисления.СтатусыЧековККМ.Аннулированный) 
	 И (НЕ ДополнительныеСвойства.Свойство("ЗагрузкаДанныхИзРабочегоМеста")) Тогда
	    	
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Чек имеет статус ""%1"". Операции над этим документом запрещены!'"),
			СтатусЧекаККМ
		);
		
		ОбщегоНазначения.СообщитьПользователю(
			Текст,
			ЭтотОбъект,
			,
			,
			Отказ
		);
		
	
	КонецЕсли;
	
	ОбщегоНазначенияРТ.УдалитьНеиспользуемыеСтрокиСерий(ЭтотОбъект,Документы.ЧекККМ.ПараметрыУказанияСерий(ЭтотОбъект));
	Если НЕ Отказ Тогда
		Если Товары.Количество() > 0 Тогда
			ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
				ЭтотОбъект,
				ОбработкаТабличнойЧастиТоварыКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС),
				"СуммаДокумента");
		Иначе
			ОбщегоНазначенияРТ.УстановитьНовоеЗначениеРеквизита(
				ЭтотОбъект,
				Оплата.Итог("Сумма"),
				"СуммаДокумента");
		КонецЕсли;
		
		Если СтатусЧекаККМ = Перечисления.СтатусыЧековККМ.Пробитый Тогда
			РаспределитьОплатуАгентскихПлатежей();
		КонецЕсли;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Отказ", Отказ);
	
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		Контрагент = Константы.КонтрагентРозничныйПокупатель.Получить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СтатусЧекаККМ           = Перечисления.СтатусыЧековККМ.ПустаяСсылка();
	ОтчетОРозничныхПродажах = Документы.ОтчетОРозничныхПродажах.ПустаяСсылка();
	ЗаказПокупателя         = Документы.ЗаказПокупателя.ПустаяСсылка();
	
	НомерСменыККМ = 0;
	НомерЧекаККМ  = 0;
	АдресЧекаЕГАИС = "";
	ПодписьЧекаЕГАИС = "";
	
	Подарки.Очистить();
	Оплата.Очистить();
	ПогашениеПодарочныхСертификатов.Очистить();
	СерийныеНомера.Очистить();
	АкцизныеМарки.Очистить();
	КодыМаркировки.Очистить();
	Серии.Очистить();
	СерииПодарков.Очистить();
	БонусныеБаллыКНачислению.Очистить();
	ПредъявленныеКодыОднократныхСкидок.Очистить();
	СкидкиНаценкиСерверПереопределяемый.ОчиститьТоварыОтПодарков(ЭтотОбъект);
	
	ОчиститьОплатуБонусамиВТоварах();
	СкидкиРассчитаны = Ложь;
	СкидкиНаценкиСервер.ОтменитьСкидки(ЭтотОбъект, "Товары", "СуммаСкидкиОплатыБонусом");
	
	Если ЗначениеЗаполнено(ЧекККМПродажа)
		И ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат Тогда
		
		ЧекККМПродажа = Документы.ЧекККМ.ПустаяСсылка();
		
	КонецЕсли;
	
	УчетНДС.СкорректироватьНДСВТЧДокумента(ЭтотОбъект, Товары);
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет проверку возможности ввода чека на основании.
//
// Параметры:
//  ДанныеЗаполнения - данные заполнения на основании.
Процедура ПроверитьВозможностьВводаНаОснованииЧекаККМ(ДанныеЗаполнения)

	// Проверить возможность ввода чека на возврат на основании чека ККМ.
	
		СтатусЧекаККМЗнач = ДанныеЗаполнения.СтатусЧекаККМ;
		Если СтатусЧекаККМЗнач = Перечисления.СтатусыЧековККМ.Аннулированный
			 ИЛИ СтатусЧекаККМЗнач = Перечисления.СтатусыЧековККМ.Отложенный Тогда
				ТекстИсключения = НСтр("ru='Ввод чека на основании чека со статусом: ""%СтатусЧекаККМ%"" не допускается.'");
				ТекстИсключения = СтрЗаменить(ТекстИсключения, "%СтатусЧекаККМ%", СтатусЧекаККМЗнач);
				ВызватьИсключение ТекстИсключения;
		КонецЕсли;
		
		Если НЕ ДанныеЗаполнения.ОперацияСДенежнымиСредствами Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ЧекККМОплата.Ссылка КАК Ссылка,
			|	ЧекККМОплата.НомерСтроки КАК НомерСтроки
			|ИЗ
			|	Документ.ЧекККМ.Оплата КАК ЧекККМОплата
			|ГДЕ
			|	ЧекККМОплата.Ссылка = &Ссылка
			|	И ЧекККМОплата.ВидОплаты.ТипОплаты = &ТипОплаты";
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
			Запрос.УстановитьПараметр("ТипОплаты", Перечисления.ТипыОплатЧекаККМ.ВРассрочку);
			
			Результат = Запрос.Выполнить();
			Если Результат.Пустой() Тогда
				ТекстИсключения = НСтр("ru='Товар отгружен и оплачен.'");
				ВызватьИсключение ТекстИсключения;
			КонецЕсли;
		КонецЕсли;
		
КонецПроцедуры

// Инициализирует документ
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
			КассаККМ      = ДанныеЗаполнения.КассаККМ;
			Магазин       = КассаККМ.Магазин;
			Организация   = КассаККМ.Владелец;
		Иначе
			Магазин       = ЗначениеНастроекПовтИсп.ПолучитьМагазинПоУмолчанию(Магазин);
			Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация,Ответственный);
			КассаККМ      = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(Организация,,КассаККМ,Магазин,);
		КонецЕсли;
	КонецЕсли;
	
	Продавец      = ЗначениеНастроекПовтИсп.ПолучитьПродавцаПоУмолчанию(Ответственный, Продавец);
	
	Если НЕ ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат Тогда
		ЦенаВключаетНДС = ОбщегоНазначенияРТ.ПолучитьЗначениеРеквизитаВПривилегированномРежиме(Магазин.ПравилоЦенообразования, "ЦенаВключаетНДС");
	КонецЕсли; 
	
	
	Если ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат Тогда
		АналитикаХозяйственнойОперации = ЗначениеНастроекПовтИсп.ПолучитьАналитикуХозяйственнойОперацииПоУмолчанию(АналитикаХозяйственнойОперации, Перечисления.ХозяйственныеОперации.ВозвратОтПокупателя);
	Иначе
		АналитикаХозяйственнойОперации = Справочники.АналитикаХозяйственныхОпераций.РеализацияТоваров;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("КассаККМ")
			И НЕ ЗначениеЗаполнено(КассаККМ) Тогда
			Если ЗначениеЗаполнено(Организация) Тогда
				Если ДанныеЗаполнения.КассаККМ.Владелец <> Организация Тогда
					ДанныеЗаполнения.КассаККМ = Справочники.КассыККМ.ПустаяСсылка();	
				КонецЕсли
			Иначе
				Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.КассаККМ, "Владелец");
			КонецЕсли;
			
			Магазин = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения.КассаККМ, "Магазин");
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля(ДополнительныеСвойства)

	Массив = Новый Массив;
	
	ИспользуетсяКомиссионнаяТорговля = ДополнительныеСвойства.ИспользуетсяКомиссионнаяТорговля;
	ИспользуетсяУчетИмпортныхТоваров = ДополнительныеСвойства.ИспользуетсяУчетИмпортныхТоваров;
	
	Если НЕ РежимРМК = Истина Тогда // Иногда может быть НЕОПРЕДЕЛЕНО.
		
		// При проведении выполняется контроль превышения остатков на складах.
		Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение 
			И НЕ ДополнительныеСвойства.Свойство("ЗагрузкаДанныхИзРабочегоМеста") Тогда
			
			Массив.Добавить(Движения.ТоварыНаСкладах);
			Массив.Добавить(Движения.ДвиженияСерийныхНомеров);
			Массив.Добавить(Движения.ЗаказыПокупателей);
			Если ВидОперации = Перечисления.ВидыОперацийЧекККМ.Возврат Тогда
				Массив.Добавить(Движения.ДенежныеСредстваККМ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура РаспределитьОплатуАгентскихПлатежей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЧекККМТовары.НомерСтроки КАК НомерСтроки,
	|	ВЫРАЗИТЬ(ЧекККМТовары.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ЧекККМТовары.Сумма
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК ЧекККМТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ЧекККМОплата.ВидОплаты КАК Справочник.ВидыОплатЧекаККМ) КАК ВидОплаты,
	|	ЧекККМОплата.ЭквайринговыйТерминал,
	|	ЧекККМОплата.Сумма,
	|	ЧекККМОплата.ПроцентКомиссии,
	|	ЧекККМОплата.СуммаКомиссии,
	|	ЧекККМОплата.СсылочныйНомер,
	|	ЧекККМОплата.НомерЧекаЭТ,
	|	ЧекККМОплата.НомерПлатежнойКарты,
	|	ЧекККМОплата.ДанныеПереданыВБанк,
	|	ЧекККМОплата.СуммаБонусовВСкидках,
	|	ЧекККМОплата.КоличествоБонусов,
	|	ЧекККМОплата.КоличествоБонусовВСкидках,
	|	ЧекККМОплата.БонуснаяПрограммаЛояльности
	|ПОМЕСТИТЬ Оплата
	|ИЗ
	|	&Оплата КАК ЧекККМОплата
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Оплата.ВидОплаты КАК ВидОплаты,
	|	Оплата.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	СУММА(Оплата.Сумма) КАК Сумма,
	|	Оплата.ПроцентКомиссии КАК ПроцентКомиссии,
	|	СУММА(Оплата.СуммаКомиссии) КАК СуммаКомиссии,
	|	Оплата.СсылочныйНомер КАК СсылочныйНомер,
	|	Оплата.НомерЧекаЭТ КАК НомерЧекаЭТ,
	|	Оплата.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	Оплата.ДанныеПереданыВБанк КАК ДанныеПереданыВБанк,
	|	СУММА(Оплата.СуммаБонусовВСкидках) КАК СуммаБонусовВСкидках,
	|	СУММА(Оплата.КоличествоБонусов) КАК КоличествоБонусов,
	|	СУММА(Оплата.КоличествоБонусовВСкидках) КАК КоличествоБонусовВСкидках,
	|	Оплата.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности
	|ПОМЕСТИТЬ ОплатаИтоговая
	|ИЗ
	|	Оплата КАК Оплата
	|СГРУППИРОВАТЬ ПО
	|	Оплата.ВидОплаты,
	|	Оплата.ЭквайринговыйТерминал,
	|	Оплата.ПроцентКомиссии,
	|	Оплата.СсылочныйНомер,
	|	Оплата.НомерЧекаЭТ,
	|	Оплата.НомерПлатежнойКарты,
	|	Оплата.ДанныеПереданыВБанк,
	|	Оплата.БонуснаяПрограммаЛояльности
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Оплата.ВидОплаты.ТипОплаты = &ПлатежнаяКарта
	|			ТОГДА 1
	|		КОГДА Оплата.ВидОплаты.ТипОплаты = &Наличные
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК ПриоритетОплаты,
	|	Оплата.ВидОплаты.ТипОплаты КАК ТипОплаты,
	|	Оплата.ВидОплаты КАК ВидОплаты,
	|	Оплата.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	Оплата.ПроцентКомиссии КАК ПроцентКомиссии,
	|	Оплата.СсылочныйНомер КАК СсылочныйНомер,
	|	Оплата.НомерЧекаЭТ КАК НомерЧекаЭТ,
	|	Оплата.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	Оплата.ДанныеПереданыВБанк КАК ДанныеПереданыВБанк,
	|	Оплата.БонуснаяПрограммаЛояльности КАК БонуснаяПрограммаЛояльности,
	|	&ПустойДоговор КАК ДоговорПлатежногоАгента,
	|	СУММА(Оплата.СуммаКомиссии) КАК СуммаКомиссии,
	|	СУММА(Оплата.Сумма) КАК Сумма,
	|	СУММА(Оплата.СуммаБонусовВСкидках) КАК СуммаБонусовВСкидках,
	|	СУММА(Оплата.КоличествоБонусов) КАК КоличествоБонусов,
	|	СУММА(Оплата.КоличествоБонусовВСкидках) КАК КоличествоБонусовВСкидках
	|ИЗ
	|	Оплата КАК Оплата
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР
	|		КОГДА Оплата.ВидОплаты.ТипОплаты = &Наличные
	|			ТОГДА 1
	|		КОГДА Оплата.ВидОплаты.ТипОплаты = &ПлатежнаяКарта
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ,
	|	Оплата.ВидОплаты.ТипОплаты,
	|	Оплата.ВидОплаты,
	|	Оплата.ЭквайринговыйТерминал,
	|	Оплата.ПроцентКомиссии,
	|	Оплата.СсылочныйНомер,
	|	Оплата.НомерЧекаЭТ,
	|	Оплата.НомерПлатежнойКарты,
	|	Оплата.ДанныеПереданыВБанк,
	|	Оплата.БонуснаяПрограммаЛояльности
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриоритетОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура.ДоговорПлатежногоАгента КАК ДоговорПлатежногоАгента,
	|	СУММА(Товары.Сумма) КАК Сумма
	|ИЗ
	|	Товары КАК Товары
	|ГДЕ
	|	Товары.Номенклатура.ДоговорПлатежногоАгента <> &ПустойДоговор
	|
	|СГРУППИРОВАТЬ ПО
	|	Товары.Номенклатура.ДоговорПлатежногоАгента
	|УПОРЯДОЧИТЬ ПО
	|	Товары.Номенклатура.ДоговорПлатежногоАгента.Наименование
	|";
	Запрос.УстановитьПараметр("Товары", Товары.Выгрузить());
	Запрос.УстановитьПараметр("Оплата", Оплата.Выгрузить());
	Запрос.УстановитьПараметр("Наличные", Перечисления.ТипыОплатЧекаККМ.Наличные);
	Запрос.УстановитьПараметр("ПлатежнаяКарта", Перечисления.ТипыОплатЧекаККМ.ПлатежнаяКарта);
	Запрос.УстановитьПараметр("ПустойДоговор", Справочники.ДоговорыПлатежныхАгентов.ПустаяСсылка());
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ТаблицаОплат = РезультатЗапроса[3].Выгрузить();
	НоваяТаблицаОплат = ТаблицаОплат.СкопироватьКолонки();
	ТаблицаАгентскихПлатежей = РезультатЗапроса[4].Выгрузить();
	
	Оплата.Очистить();
	
	Для Каждого АгентскаяСтрока Из ТаблицаАгентскихПлатежей Цикл
		Если АгентскаяСтрока.Сумма > 0 Тогда
			МассивУдаляемыхСтрок = Новый Массив;
			Для Каждого СтрокаОплаты Из ТаблицаОплат Цикл
				Если СтрокаОплаты.Сумма <= 0
					ИЛИ СтрокаОплаты.ТипОплаты = Перечисления.ТипыОплатЧекаККМ.Бонусы
					ИЛИ ЗначениеЗаполнено(СтрокаОплаты.ДоговорПлатежногоАгента) Тогда
					Продолжить;
				КонецЕсли;
				Если СтрокаОплаты.Сумма > АгентскаяСтрока.Сумма Тогда
					НоваяСтрока = НоваяТаблицаОплат.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОплаты);
					НоваяСтрока.ДоговорПлатежногоАгента = АгентскаяСтрока.ДоговорПлатежногоАгента;
					НоваяСтрока.Сумма = АгентскаяСтрока.Сумма;
					СтрокаОплаты.Сумма = СтрокаОплаты.Сумма - АгентскаяСтрока.Сумма;
					АгентскаяСтрока.Сумма = 0;
					Прервать;
				Иначе
					НоваяСтрока = НоваяТаблицаОплат.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОплаты);
					НоваяСтрока.ДоговорПлатежногоАгента = АгентскаяСтрока.ДоговорПлатежногоАгента;
					НоваяСтрока.Сумма = СтрокаОплаты.Сумма;
					АгентскаяСтрока.Сумма = АгентскаяСтрока.Сумма - СтрокаОплаты.Сумма;
					СтрокаОплаты.Сумма = 0;
					МассивУдаляемыхСтрок.Добавить(СтрокаОплаты);
					Если АгентскаяСтрока.Сумма = 0 Тогда
						Прервать;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Для Каждого УдаляемаяСтрока Из МассивУдаляемыхСтрок Цикл
				ТаблицаОплат.Удалить(УдаляемаяСтрока);
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Для Каждого СтрокаОплаты Из НоваяТаблицаОплат Цикл
		НоваяСтрока = ТаблицаОплат.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОплаты);
	КонецЦикла;
	
	Оплата.Загрузить(ТаблицаОплат);
	
КонецПроцедуры

Процедура ОчиститьОплатуБонусамиВТоварах()
	Для Каждого СтрокаТовара Из Товары Цикл
		СтрокаТовара.КодСтроки = 0;
		Если СтрокаТовара.СуммаСкидкиОплатыБонусом <> 0 Тогда
			СтрокаТовара.Сумма = СтрокаТовара.Сумма + СтрокаТовара.СуммаСкидкиОплатыБонусом;
			СтрокаТовара.СуммаСкидкиОплатыБонусом = 0;
			СтрокаТовара.СуммаНДС = ОбработкаТабличнойЧастиТоварыСервер.РассчитатьСуммуНДС(СтрокаТовара.Сумма,
																							СтрокаТовара.СтавкаНДС,
																							ЦенаВключаетНДС);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция СтатусЧекаККМПоСсылке(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЧекККМ.СтатусЧекаККМ
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат ВыБорка.СтатусЧекаККМ
	Иначе
		Возврат Перечисления.СтатусыЧековККМ.ПустаяСсылка()
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьЗачетАванса()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РасчетыСКлиентамиОстатки.ДокументРасчета,
	|	РасчетыСКлиентамиОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки(, ДокументРасчета = &ДокументРасчета) КАК РасчетыСКлиентамиОстатки
	|ГДЕ
	|	РасчетыСКлиентамиОстатки.СуммаОстаток > 0";
	
	Запрос.УстановитьПараметр("ДокументРасчета", ДокументРасчета);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтрокаОплаты = Оплата.Добавить();
		
		СтрокаОплаты.ВидОплаты = Справочники.ВидыОплатЧекаККМ.ЗачетАванса;
		СтрокаОплаты.Сумма = Выборка.Сумма;
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область ОсновнойБлок

РежимРМК = Ложь;
КонтролироватьОстаткиТоваровПриЗакрытииЧека = Ложь;
мЗакрытиеСмены = Ложь;

#КонецОбласти

#КонецЕсли
