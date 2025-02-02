﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Не УказыватьПриОтгрузке
		И Не УказыватьПриПриемке
		И Не УказыватьПриОтраженииИзлишковНедостачПорчи Тогда
		
		ТекстСообщения = НСтр("ru = 'Необходимо указать хотя бы одну складскую операцию, когда необходимо указывать серии.'");
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
	КонецЕсли;
	
	Если УказыватьПриОтгрузке
		И Не УказыватьПриОтгрузкеПоПеремещению
		И Не УказыватьПриОтгрузкеПоВозвратуПоставщику
		И Не УказыватьПриОтгрузкеКлиенту
		И Не УказыватьПриОтгрузкеВРозницу
		И Не УказыватьПриОтгрузкеКомплектующихДляСборки
		И Не УказыватьПриОтгрузкеКомплектовДляРазборки Тогда
		
		ТекстСообщения = НСтр("ru = 'Включена политика указания серий при отгрузке,
									|но не выбрано ни одной операции отгрузки, когда необходимо указывать серии'");
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"УказыватьПриОтгрузке","Объект",Отказ);
		
	КонецЕсли;
	
	Если УказыватьПриПриемке
		И Не УказыватьПриПриемкеОтПоставщика 
		И Не УказыватьПриПриемкеПоВозвратуОтКлиента 
		И Не УказыватьПриПриемкеСобранныхКомплектов 
		И Не УказыватьПриПриемкеПоПеремещению 
		И Не УказыватьПриПриемкеКомплектующихПослеРазборки Тогда
		
		ТекстСообщения = НСтр("ru = 'Включена политика указания серий при приемке,
									|но не выбрано ни одной операции приемки, когда необходимо указывать серии'");
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"УказыватьПриПриемке","Объект",Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли