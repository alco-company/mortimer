// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import { Alert } from "tailwindcss-stimulus-components"
application.register('alert', Alert)

import { Dropdown } from "tailwindcss-stimulus-components"
application.register('dropdown', Dropdown)

import { Tabs } from "tailwindcss-stimulus-components"
application.register('tabs', Tabs)

import { Popover } from "tailwindcss-stimulus-components"
application.register('popover', Popover)

import ContentLoaderController from "./content_loader_controller.js"
application.register("content-loader", ContentLoaderController)

import FlagController from "./flag_controller.js"
application.register("flag", FlagController)

import FormController from "./form_controller.js"
application.register("form", FormController)

import FormSleeveController from "./form_sleeve_controller.js"
application.register("form-sleeve", FormSleeveController)

import ListController from "./list_controller.js"
application.register("list", ListController)

import ListItemActionsController from "./list_item_actions_controller.js"
application.register("list-item-actions", ListItemActionsController)

import ListItemController from "./list_item_controller.js"
application.register("list-item", ListItemController)

import PaginationController from "./pagination_controller.js"
application.register("pagination", PaginationController)

import SearchController from "./search_controller.js"
application.register("search", SearchController)

import StockPosController from "./stock_pos_controller.js"
application.register("stock-pos", StockPosController)

import EmployeePosController from "./employee_pos_controller.js"
application.register("employee-pos", EmployeePosController)

import EmployeePupilController from "./employee_pupil_controller.js"
application.register("employee-pupil", EmployeePupilController)

import SwitchboardController from "./switchboard_controller.js"
application.register("switchboard", SwitchboardController)

import UiModalController from "./ui_modal_controller.js"
application.register("ui-modal", UiModalController)
