const gameWidth = 820.0;
const gameHeight = 1600.0;

const blockHeight = 40.0;
const baseWidth = 360.0;
const baseBottomMargin = 120.0; // distance from bottom of the screen
const spawnDropGap = 220.0;     // how far above the landing y the moving block appears
const horizontalMargin = 32.0;  // left/right padding for movement bounds

enum Level { easy, medium, hard }

const levelSpeeds = {
  Level.easy: 220.0,
  Level.medium: 360.0,
  Level.hard: 520.0,
};

const dropSpeed = 1200.0; // vertical drop speed (px/s)
const minWidthToContinue = 5.0; // game over if trimmed below this
const perfectTolerance = 5.0;   // snap perfects within this tolerance
