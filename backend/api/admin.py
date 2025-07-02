#!/usr/bin/python3
"""
Registers Naviplus API models in Django admin for management.
"""

from django.contrib import admin
from .models import Building, PLD, UserProfile

# Registering models to appear in the Django Admin UI
admin.site.register(Building)
admin.site.register(PLD)
admin.site.register(UserProfile)