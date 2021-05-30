class RscActivePicture;

//main display class
class crowsZA_drawbuild_display {
    idd = -1;
    movingEnable = 1;
    onLoad = "uiNamespace setVariable ['crowsZA_drawbuild_display',_this select 0];";
    class controls {
        class Title: RscText {
            idc = IDC_TITLE;
            x = POS_X(11.5);
            w = POS_W(15);
            h = POS_H(1);
            colorBackground[] = GUI_THEME_COLOR;
            moving = 1;
            text = "Select Object To Build";
        };
        class Background: RscText {
            idc = IDC_BACKGROUND;
            x = POS_X(11.5);
            w = POS_W(15);
            h = POS_H(4);
            colorBackground[] = {0, 0, 0, 0.7};
        };
        class Content: RscControlsGroupNoScrollbars {
            idc = IDC_CONTENT;
            h = POS_H(3);
            x = POS_X(12);
            w = POS_W(14);
            class controls {
                class grid1: RscActivePicture {
                    idc = IDC_ICON_GRID_FIRST;
                    text = "\A3\EditorPreviews_F\Data\CfgVehicles\Land_BagFence_Short_F.jpg";
                    color[] = {1,1,1,0.8}; //change from 0.5 alpha to not be too dark but still show when hovered
                    tooltip = "";
                    x = 0;
                    y = POS_H(0.5);
                    w = POS_W(2);
                    h = POS_H(2);
                };
                class grid2: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 1;
                    x = POS_W(3);
                };
                class grid3: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 2;
                    x = POS_W(6);
                };
                class grid4: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 3;
                    x = POS_W(9);
                };
                class grid5: grid1 {
                    idc = IDC_ICON_GRID_FIRST + 4;
                    x = POS_W(12);
                };
            };
        };
    };
};
