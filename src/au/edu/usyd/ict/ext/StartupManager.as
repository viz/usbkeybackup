package au.edu.usyd.ict.ext
{
	import au.edu.usyd.ict.ext.interfaces.IStartupElement;
	import au.edu.usyd.ict.USBKeyBackup.ApplicationFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.observer.Observer;
	import org.puremvc.as3.core.View;
	
	import flash.utils.Dictionary;
	
	public class StartupManager
	{
		private var managedElement:IStartupElement;
		private var dependencies:Dictionary = new Dictionary();
		private var initComplete:Boolean = false;
		
		public function StartupManager(obj:IStartupElement)
		{
			managedElement = obj;
			View.getInstance().registerObserver(ApplicationFacade.INIT_SUCCESS,	new Observer(dependencyInitSuccess,this));
		}

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
			// this approach is inefficient - every Proxy and Mediator will receive every notification
			// if this becomes a problem, refactor this to have specific notifications for each object
			// based on a naming convention so we don't have to add all these into the ApplicationFacade
			// Then the requires(obj) function above could create a specific objserver for that object's notifications
			
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
			
			if (satisfied && !initComplete) managedElement.init();  
		}
		
		public function set initialised(val:Boolean):void
		{
			initComplete = val;
		}


	}
}