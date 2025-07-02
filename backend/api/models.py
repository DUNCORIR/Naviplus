#!/usr/bin/python3
"""
This module defines database models for the Naviplus system,
which supports accessible navigation in urban environments.

Models:
- Building: Represents a physical building with GPS coordinates.
- PLD: Physical Location Descriptor — detailed info about building entrances.
- UserProfile: Extends user accounts with accessibility needs.
"""

from django.db import models
from django.contrib.auth.models import User


class Building(models.Model):
    """
    Represents a public or private building in the Naviplus network.
    """
    name = models.CharField(max_length=100)  # Name of the building
    description = models.TextField(blank=True)  # Optional description
    latitude = models.FloatField()  # GPS latitude of the building
    longitude = models.FloatField()  # GPS longitude of the building

    def __str__(self):
        # String representation for admin interface or logging
        return self.name


class PLD(models.Model):
    """
    Describes specific entrances or nodes within a building
    that broadcast accessibility data to users.
    """
    building = models.ForeignKey(
        Building, on_delete=models.CASCADE, related_name='plds'
    )  # Link to parent building
    entrance_name = models.CharField(max_length=100)  # Label for the entrance
    entrance_lat = models.FloatField()  # GPS latitude of the entrance
    entrance_lng = models.FloatField()  # GPS longitude of the entrance
    accessibility_features = models.TextField()  
    # Comma-separated features, e.g. "ramp,elevator,braille"

    def __str__(self):
        return f"{self.entrance_name} ({self.building.name})"


class UserProfile(models.Model):
    """
    Extends the built-in User model with disability-related metadata.
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE)  
    # One profile per user account
    DISABILITY_CHOICES = [
        ('vision', 'Visually Impaired'),
        ('mobility', 'Mobility Impaired'),
        ('hearing', 'Hearing Impaired'),
    ]
    disability_type = models.CharField(
        max_length=20, choices=DISABILITY_CHOICES
    )  # Type of disability for personalized navigation

    def __str__(self):
        return f"{self.user.username} - {self.get_disability_type_display()}"
