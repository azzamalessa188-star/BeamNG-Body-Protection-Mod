angular.module('beamng.apps')
.directive('bodyProtection', ['$interval', '$log', function ($interval, $log) {
  return {
    template: `
<div style="
  width: 100%;
  height: 100%;
  box-sizing: border-box;
  background: rgba(14, 18, 24, 0.90);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 12px;
  backdrop-filter: blur(8px);
  padding: 10px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  font-family: 'Roboto', 'Segoe UI', Tahoma, sans-serif;
  user-select: none;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
  color: #fff;
">
  <!-- Header / Title -->
  <div style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 5px;">
    <div style="display: flex; align-items: center; gap: 6px;">
      <svg viewBox="0 0 24 24" style="width: 18px; height: 18px; fill: {{ isEnabled ? '#00e676' : '#ff1744' }}; transition: fill 0.3s ease;">
        <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>
      </svg>
      <span style="font-size: 13px; font-weight: bold; letter-spacing: 0.5px;">درع البدي | SHIELD</span>
    </div>
    <!-- Status Indicator Pill -->
    <span style="
      font-size: 10px;
      font-weight: 700;
      padding: 2px 7px;
      border-radius: 10px;
      text-transform: uppercase;
      background: {{ isEnabled ? 'rgba(0, 230, 118, 0.2)' : 'rgba(255, 23, 68, 0.2)' }};
      color: {{ isEnabled ? '#00e676' : '#ff5252' }};
      border: 1px solid {{ isEnabled ? 'rgba(0, 230, 118, 0.4)' : 'rgba(255, 23, 68, 0.4)' }};
      transition: all 0.3s ease;
    ">
      {{ isEnabled ? 'ON مفعّل' : 'OFF معطّل' }}
    </span>
  </div>

  <!-- Subtitle note -->
  <div style="font-size: 10px; color: #aaa; text-align: center; margin: 2px 0;">
    {{ isEnabled ? 'جسم السيارة محمي • الصدامات تتأثر فقط' : 'الوضع الطبيعي • كل أجزاء السيارة تتأثر' }}
  </div>

  <!-- The Two Buttons: ON and OFF -->
  <div style="display: flex; gap: 10px; height: 44px; margin-top: 2px;">
    <!-- ON Button -->
    <button type="button" ng-click="setEnabled(true)" style="
      flex: 1;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      font-size: 15px;
      font-weight: 900;
      transition: all 0.2s ease;
      background: {{ isEnabled ? 'linear-gradient(135deg, #00c853, #00e676)' : 'rgba(255, 255, 255, 0.08)' }};
      color: {{ isEnabled ? '#000' : '#888' }};
      box-shadow: {{ isEnabled ? '0 0 16px rgba(0, 230, 118, 0.6), inset 0 1px 0 rgba(255,255,255,0.4)' : 'none' }};
      transform: {{ isEnabled ? 'scale(1.02)' : 'scale(1)' }};
    ">
      <span style="font-size: 16px;">✓</span> ON
    </button>

    <!-- OFF Button -->
    <button type="button" ng-click="setEnabled(false)" style="
      flex: 1;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      font-size: 15px;
      font-weight: 900;
      transition: all 0.2s ease;
      background: {{ !isEnabled ? 'linear-gradient(135deg, #d50000, #ff1744)' : 'rgba(255, 255, 255, 0.08)' }};
      color: {{ !isEnabled ? '#fff' : '#888' }};
      box-shadow: {{ !isEnabled ? '0 0 16px rgba(255, 23, 68, 0.6), inset 0 1px 0 rgba(255,255,255,0.4)' : 'none' }};
      transform: {{ !isEnabled ? 'scale(1.02)' : 'scale(1)' }};
    ">
      <span style="font-size: 15px;">✕</span> OFF
    </button>
  </div>
</div>
    `,
    replace: true,
    restrict: 'EA',
    scope: true,
    link: function (scope, element, attrs) {
      scope.isEnabled = false;

      scope.setEnabled = function(state) {
        if (window.bngApi) {
          window.bngApi.engineLua('if extensions.bodyProtection then extensions.bodyProtection.setInvincibility(' + (state ? 'true' : 'false') + ') end');
        }
      };

      scope.$on('BodyProtectionState', function(event, data) {
        if (data && typeof data.enabled === 'boolean') {
          scope.$evalAsync(function() {
            scope.isEnabled = data.enabled;
          });
        }
      });

      // Request initial state upon app load
      if (window.bngApi) {
        window.bngApi.engineLua('if extensions.bodyProtection then extensions.bodyProtection.requestState() end');
      }
    }
  };
}]);
