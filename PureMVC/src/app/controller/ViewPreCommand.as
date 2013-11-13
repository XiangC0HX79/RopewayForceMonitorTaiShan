package app.controller
{	
	
	import app.view.ApplicationMediator;
	import app.view.AreaTitleWindowMediator;
	import app.view.ContentManageMediator;
	import app.view.LoadingBarMediator;
	import app.view.MainConentMediator;
	import app.view.MainMenuMediator;
	import app.view.MainStationMediator;
	import app.view.PanelRopewayAlarmMediator;
	import app.view.StandStationMediator;
	import app.view.TitleWindowBaseInfoMediator;
	import app.view.TitleWindowManageMediator;
	import app.view.TitleWindowStandMaintainMediator;
	import app.view.TitleWindowStandMediator;
	import app.view.WheelGroupMediator;
	import app.view.components.AreaTitleWindow;
	import app.view.components.ContentManage;
	import app.view.components.MainContent;
	import app.view.components.PanelRopewayAlarm;
	import app.view.components.TitleWindowBaseInfo;
	import app.view.components.TitleWindowManage;
	import app.view.components.TitleWindowStand;
	import app.view.components.TitleWindowStandMaintain;
	import app.view.components.WheelGroup;
	import app.view.components.contentcomponents.StandStation;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import spark.components.Application;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:PurMVC = note.getBody() as PurMVC;
			
			facade.registerMediator(new PanelRopewayAlarmMediator);
			facade.registerMediator(new ApplicationMediator(application));
			facade.registerMediator(new MainConentMediator(new MainContent));
			facade.registerMediator(new LoadingBarMediator(application.mainLoading));
			facade.registerMediator(new MainStationMediator(application.mainStation));
			facade.registerMediator(new MainMenuMediator(application.mainMenu));
			facade.registerMediator(new ContentManageMediator(new ContentManage));
			facade.registerMediator(new StandStationMediator(new StandStation));	
			
			facade.registerMediator(new WheelGroupMediator(new WheelGroup));			
			facade.registerMediator(new AreaTitleWindowMediator(new AreaTitleWindow));
			facade.registerMediator(new TitleWindowBaseInfoMediator(new TitleWindowBaseInfo));	
			facade.registerMediator(new TitleWindowManageMediator(new TitleWindowManage));
			facade.registerMediator(new TitleWindowStandMediator(new TitleWindowStand));
			facade.registerMediator(new TitleWindowStandMaintainMediator(new TitleWindowStandMaintain));
		}
	}
}