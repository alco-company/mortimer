// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ContentLoaderController from "./content_loader_controller"
application.register("content-loader", ContentLoaderController)

import EmployeePosController from "./employee_pos_controller"
application.register("employee-pos", EmployeePosController)

import EmployeePupilController from "./employee_pupil_controller"
application.register("employee-pupil", EmployeePupilController)

import FlagController from "./flag_controller"
application.register("flag", FlagController)

import FormController from "./form_controller"
application.register("form", FormController)

import FormSleeveController from "./form_sleeve_controller"
application.register("form-sleeve", FormSleeveController)

import ListController from "./list_controller"
application.register("list", ListController)

import ListItemActionsController from "./list_item_actions_controller"
application.register("list-item-actions", ListItemActionsController)

import ListItemController from "./list_item_controller"
application.register("list-item", ListItemController)

import PaginationController from "./pagination_controller"
application.register("pagination", PaginationController)

import PunchClockController from "./punch_clock_controller"
application.register("punch-clock", PunchClockController)

import SearchController from "./search_controller"
application.register("search", SearchController)

import StockPosController from "./stock_pos_controller"
application.register("stock-pos", StockPosController)

import SwitchboardController from "./switchboard_controller"
application.register("switchboard", SwitchboardController)

import UiModalController from "./ui_modal_controller"
application.register("ui-modal", UiModalController)

import { Alert } from "tailwindcss-stimulus-components"
application.register('alert', Alert)

import { Dropdown } from "tailwindcss-stimulus-components"
application.register('dropdown', Dropdown)

import { Tabs } from "tailwindcss-stimulus-components"
application.register('tabs', Tabs)

import { Popover } from "tailwindcss-stimulus-components"
application.register('popover', Popover)
