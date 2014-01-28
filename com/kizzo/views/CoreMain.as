package com.kizzo.views
{

    import com.greensock.TweenMax;

	import feathers.controls.ProgressBar;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Sprite;
	import starling.utils.AssetManager;

	public class CoreMain extends Sprite
	{
		private var mLoadingProgress:ProgressBar;
		private var assetsManager:AssetManager;


		public function loadAssets(assets:AssetManager):void
		{
			new MetalWorksMobileTheme();

			mLoadingProgress = new ProgressBar();

			mLoadingProgress.minimum = 0;
			mLoadingProgress.maximum = 100;
			mLoadingProgress.width = 200;
			mLoadingProgress.height = 20;
			mLoadingProgress.x = (stage.stageWidth - mLoadingProgress.width) / 2;
			mLoadingProgress.y = stage.stageHeight * 0.9;


			addChild(mLoadingProgress);

			assets.loadQueue(function (ratio:Number):void
			{
				mLoadingProgress.value = ratio*100;

				if (ratio == 1)
                TweenMax.delayedCall(1,
					function ():void
						{
							mLoadingProgress.removeFromParent(true);
							mLoadingProgress = null;
							assetsManager = assets;
							TweenMax.delayedCall(.5, createMain);
						}
					);
			});
		}

		private function createMain():void
		{
			var editor:MultiTweenEditor = new MultiTweenEditor();
			addChild(editor);
		}

    }
}