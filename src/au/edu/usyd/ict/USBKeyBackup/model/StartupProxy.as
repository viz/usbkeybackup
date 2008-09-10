package au.edu.usyd.ict.USBKeyBackup.model
{
	import au.edu.usyd.ict.USBKeyBackup.ApplicationFacade;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.core.View;
	import org.puremvc.as3.patterns.observer.Observer;
	
	import flash.utils.Dictionary;
	
	/**
	 * A proxy for tracking the startup dependencies and progress
	 * 
	 */


	public class StartupProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "StartupProxy";
		
		public function StartupProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);

			View.getInstance().registerObserver(ApplicationFacade.INIT_SUCCESS,	new Observer(dependencyInitSuccess,this));

		}
		
		// stuff to handle startup dependencies - will refactor this into Interface and ancestor of Proxy and Mediator
		
		private var dependencies:Dictionary = new Dictionary();
		
		public function requires(obj:Object):void
		{
			// adds obj to list of required objects
			dependencies[obj] = false;
			// register interest in obj's init_success notification
			// - create an Observer instance
			// - register observer with the view
			
		}
		
		public function dependencyInitSuccess(notification:INotification):void
		{
			// get object from notification
			var obj:Object = notification.getBody();
			// check dictionary and set object status to true if present
			if (dependencies[obj] != null)
			{
			  dependencies[obj] = true;
			}
			// check to see if all dependencies are initialised
			// call init() if so
			var satisfied:Boolean = true;
			for each (var state:Boolean in dependencies)
			{
			  satisfied = satisfied && state;	
			}
			
			if (satisfied) init();  
		}
		
		public function init():void
		{
			sendNotification(ApplicationFacade.APP_STARTUP_SUCCESS);
		}
		
	}
}