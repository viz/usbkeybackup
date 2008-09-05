package au.edu.usyd.ict.USBKeyBackup.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class ApplicationStartupCommand extends MacroCommand implements ICommand
	{
		public function ApplicationStartupCommand()
		{
			super();
		}
		
		override protected function initializeMacroCommand():void
		{
//			addSubCommand(???.controller.PrepViewCommand);
		}
		
	}
}